import axios from 'axios';
import { VolcSignature } from './signature';
import { config } from './config';

export interface SearchQuery {
  index: string;
  query: any;
  from?: number;
  size?: number;
  sort?: any[];
  _source?: string[];
  highlight?: any;
}

export interface SearchResult {
  took: number;
  timed_out: boolean;
  hits: {
    total: {
      value: number;
      relation: string;
    };
    hits: Array<{
      _index: string;
      _id: string;
      _score: number;
      _source: any;
      highlight?: Record<string, string[]>;
    }>;
  };
  aggregations?: any;
}

export class VolcSearchClient {
  private baseUrl: string;

  constructor() {
    this.baseUrl = config.searchDomain.startsWith('http') 
      ? config.searchDomain 
      : `https://${config.searchDomain}`;
  }

  /**
   * Execute search query
   * @param params Search parameters
   * @returns Search results
   */
  async search(params: SearchQuery): Promise<SearchResult> {
    const { index, ...body } = params;
    const path = `/${index}/_search`;
    
    const signedHeaders = VolcSignature.sign({
      method: 'POST',
      path,
      body,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
      region: config.region,
      service: config.service,
    });

    try {
      const response = await axios.post(`${this.baseUrl}${path}`, body, {
        headers: signedHeaders,
        timeout: 30000,
      });

      return response.data;
    } catch (error: any) {
      if (error.response) {
        throw new Error(`Search API error: ${error.response.status} - ${JSON.stringify(error.response.data)}`);
      }
      throw new Error(`Search request failed: ${error.message}`);
    }
  }

  /**
   * Simple search with query string
   * @param index Index name
   * @param q Query string
   * @param size Number of results to return
   * @returns Search results
   */
  async simpleSearch(index: string, q: string, size: number = 10): Promise<SearchResult> {
    return this.search({
      index,
      query: {
        query_string: {
          query: q,
        },
      },
      size,
    });
  }

  /**
   * Match search
   * @param index Index name
   * @param field Field to search
   * @param query Search text
   * @param size Number of results to return
   * @returns Search results
   */
  async matchSearch(index: string, field: string, query: string, size: number = 10): Promise<SearchResult> {
    return this.search({
      index,
      query: {
        match: {
          [field]: query,
        },
      },
      size,
    });
  }

  /**
   * Get document by ID
   * @param index Index name
   * @param id Document ID
   * @returns Document
   */
  async getDocument(index: string, id: string): Promise<any> {
    const path = `/${index}/_doc/${id}`;
    
    const signedHeaders = VolcSignature.sign({
      method: 'GET',
      path,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
      region: config.region,
      service: config.service,
    });

    try {
      const response = await axios.get(`${this.baseUrl}${path}`, {
        headers: signedHeaders,
        timeout: 30000,
      });

      return response.data;
    } catch (error: any) {
      if (error.response?.status === 404) {
        return null;
      }
      if (error.response) {
        throw new Error(`Get document error: ${error.response.status} - ${JSON.stringify(error.response.data)}`);
      }
      throw new Error(`Get document request failed: ${error.message}`);
    }
  }

  /**
   * Count documents matching query
   * @param index Index name
   * @param query Query DSL
   * @returns Count result
   */
  async count(index: string, query?: any): Promise<{ count: number }> {
    const path = `/${index}/_count`;
    const body = query ? { query } : {};
    
    const signedHeaders = VolcSignature.sign({
      method: 'POST',
      path,
      body,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
      region: config.region,
      service: config.service,
    });

    try {
      const response = await axios.post(`${this.baseUrl}${path}`, body, {
        headers: signedHeaders,
        timeout: 30000,
      });

      return response.data;
    } catch (error: any) {
      if (error.response) {
        throw new Error(`Count API error: ${error.response.status} - ${JSON.stringify(error.response.data)}`);
      }
      throw new Error(`Count request failed: ${error.message}`);
    }
  }
}

export const volcSearchClient = new VolcSearchClient();
