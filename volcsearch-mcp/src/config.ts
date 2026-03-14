import { z } from 'zod';
import dotenv from 'dotenv';

dotenv.config();

const configSchema = z.object({
  accessKey: z.string().min(1, 'VOLC_ACCESS_KEY is required'),
  secretKey: z.string().min(1, 'VOLC_SECRET_KEY is required'),
  region: z.string().default('cn-beijing'),
  searchDomain: z.string().min(1, 'VOLC_SEARCH_DOMAIN is required'),
  service: z.string().default('es'),
  apiVersion: z.string().default('2018-01-01'),
  port: z.coerce.number().default(3000),
});

export const config = configSchema.parse({
  accessKey: process.env.VOLC_ACCESS_KEY,
  secretKey: process.env.VOLC_SECRET_KEY,
  region: process.env.VOLC_REGION,
  searchDomain: process.env.VOLC_SEARCH_DOMAIN,
  service: process.env.VOLC_SERVICE,
  apiVersion: process.env.VOLC_API_VERSION,
  port: process.env.PORT,
});

export type Config = z.infer<typeof configSchema>;
