import * as crypto from 'crypto';
import * as querystring from 'querystring';

interface SignRequestParams {
  method: string;
  path: string;
  query?: Record<string, any>;
  headers?: Record<string, string>;
  body?: any;
  accessKey: string;
  secretKey: string;
  region: string;
  service: string;
}

/**
 * Volcengine API signature implementation
 * Reference: https://www.volcengine.com/docs/6450/107748
 */
export class VolcSignature {
  private static ALGORITHM = 'HMAC-SHA256';
  private static CONTENT_TYPE = 'application/json';

  static sign(params: SignRequestParams): Record<string, string> {
    const { method, path, query = {}, headers = {}, body, accessKey, secretKey, region, service } = params;
    
    const now = new Date();
    const date = now.toISOString().replace(/[:-]|\.\d{3}/g, '');
    const datestamp = date.slice(0, 8);
    
    // Step 1: Create canonical request
    const canonicalUri = path;
    const canonicalQuerystring = this.getCanonicalQueryString(query);
    const canonicalHeaders = this.getCanonicalHeaders(headers, date);
    const signedHeaders = this.getSignedHeaders(headers);
    const hashedPayload = this.hash(body ? JSON.stringify(body) : '');

    const canonicalRequest = [
      method.toUpperCase(),
      canonicalUri,
      canonicalQuerystring,
      canonicalHeaders,
      signedHeaders,
      hashedPayload
    ].join('\n');

    // Step 2: Create the string to sign
    const credentialScope = `${datestamp}/${region}/${service}/request`;
    const stringToSign = [
      this.ALGORITHM,
      date,
      credentialScope,
      this.hash(canonicalRequest)
    ].join('\n');

    // Step 3: Calculate the signature
    const kSecret = `VOLC${secretKey}`;
    const kDate = this.hmac(kSecret, datestamp);
    const kRegion = this.hmac(kDate, region);
    const kService = this.hmac(kRegion, service);
    const kSigning = this.hmac(kService, 'request');
    const signature = this.hmac(kSigning, stringToSign, 'hex');

    // Step 4: Build authorization header
    const authorization = `${this.ALGORITHM} Credential=${accessKey}/${credentialScope}, SignedHeaders=${signedHeaders}, Signature=${signature}`;

    return {
      'Host': headers.host || this.getHost(service, region),
      'X-Date': date,
      'Content-Type': this.CONTENT_TYPE,
      'Authorization': authorization
    };
  }

  private static getCanonicalQueryString(query: Record<string, any>): string {
    const sortedKeys = Object.keys(query).sort();
    const canonicalQuery: Record<string, string> = {};
    
    for (const key of sortedKeys) {
      const value = query[key];
      if (value === undefined || value === null) continue;
      canonicalQuery[key] = encodeURIComponent(String(value));
    }
    
    return querystring.stringify(canonicalQuery);
  }

  private static getCanonicalHeaders(headers: Record<string, string>, date: string): string {
    const normalizedHeaders: Record<string, string> = {
      'content-type': this.CONTENT_TYPE,
      'x-date': date,
      ...Object.fromEntries(
        Object.entries(headers).map(([key, value]) => [key.toLowerCase(), value.trim()])
      )
    };

    const sortedKeys = Object.keys(normalizedHeaders).sort();
    return sortedKeys.map(key => `${key}:${normalizedHeaders[key]}\n`).join('');
  }

  private static getSignedHeaders(headers: Record<string, string>): string {
    const normalizedHeaders = {
      'content-type': true,
      'x-date': true,
      ...Object.fromEntries(
        Object.keys(headers).map(key => [key.toLowerCase(), true])
      )
    };

    return Object.keys(normalizedHeaders).sort().join(';');
  }

  private static getHost(service: string, region: string): string {
    return `${service}.volcengineapi.com`;
  }

  private static hash(str: string): string {
    return crypto.createHash('sha256').update(str).digest('hex');
  }

  private static hmac(key: string | Buffer, data: string, encoding: crypto.BinaryToTextEncoding = 'hex'): string {
    return crypto.createHmac('sha256', key).update(data).digest(encoding);
  }
}
