import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { volcSearchClient, SearchQuery } from './client';
import { config } from './config';

// Define tool schemas
const SearchArgsSchema = z.object({
  index: z.string().describe('Index name to search'),
  query: z.any().describe('Elasticsearch Query DSL object'),
  from: z.number().optional().describe('Starting offset (default: 0)'),
  size: z.number().optional().describe('Number of results to return (default: 10)'),
  sort: z.array(z.any()).optional().describe('Sort configuration'),
  _source: z.array(z.string()).optional().describe('Fields to include in results'),
  highlight: z.any().optional().describe('Highlight configuration'),
});

const SimpleSearchArgsSchema = z.object({
  index: z.string().describe('Index name to search'),
  q: z.string().describe('Query string (uses query_string query)'),
  size: z.number().optional().describe('Number of results to return (default: 10)'),
});

const MatchSearchArgsSchema = z.object({
  index: z.string().describe('Index name to search'),
  field: z.string().describe('Field to search in'),
  query: z.string().describe('Search text'),
  size: z.number().optional().describe('Number of results to return (default: 10)'),
});

const GetDocumentArgsSchema = z.object({
  index: z.string().describe('Index name'),
  id: z.string().describe('Document ID'),
});

const CountArgsSchema = z.object({
  index: z.string().describe('Index name'),
  query: z.any().optional().describe('Optional Query DSL to filter documents'),
});

// Define tools
const tools: Tool[] = [
  {
    name: 'volcsearch_search',
    description: 'Execute a full Elasticsearch search with custom Query DSL',
    inputSchema: {
      type: 'object',
      properties: {
        index: { type: 'string', description: 'Index name to search' },
        query: { type: 'object', description: 'Elasticsearch Query DSL object' },
        from: { type: 'number', description: 'Starting offset (default: 0)' },
        size: { type: 'number', description: 'Number of results to return (default: 10)' },
        sort: { type: 'array', description: 'Sort configuration' },
        _source: { type: 'array', items: { type: 'string' }, description: 'Fields to include in results' },
        highlight: { type: 'object', description: 'Highlight configuration' },
      },
      required: ['index', 'query'],
    },
  },
  {
    name: 'volcsearch_simple_search',
    description: 'Simple search using query string syntax',
    inputSchema: {
      type: 'object',
      properties: {
        index: { type: 'string', description: 'Index name to search' },
        q: { type: 'string', description: 'Query string (uses query_string query)' },
        size: { type: 'number', description: 'Number of results to return (default: 10)' },
      },
      required: ['index', 'q'],
    },
  },
  {
    name: 'volcsearch_match_search',
    description: 'Full-text search on a specific field',
    inputSchema: {
      type: 'object',
      properties: {
        index: { type: 'string', description: 'Index name to search' },
        field: { type: 'string', description: 'Field to search in' },
        query: { type: 'string', description: 'Search text' },
        size: { type: 'number', description: 'Number of results to return (default: 10)' },
      },
      required: ['index', 'field', 'query'],
    },
  },
  {
    name: 'volcsearch_get_document',
    description: 'Get a document by ID',
    inputSchema: {
      type: 'object',
      properties: {
        index: { type: 'string', description: 'Index name' },
        id: { type: 'string', description: 'Document ID' },
      },
      required: ['index', 'id'],
    },
  },
  {
    name: 'volcsearch_count',
    description: 'Count documents matching a query',
    inputSchema: {
      type: 'object',
      properties: {
        index: { type: 'string', description: 'Index name' },
        query: { type: 'object', description: 'Optional Query DSL to filter documents' },
      },
      required: ['index'],
    },
  },
];

async function main() {
  const server = new Server(
    {
      name: 'volcsearch-mcp',
      version: '1.0.0',
    },
    {
      capabilities: {
        tools: {},
      },
    }
  );

  // List tools handler
  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return { tools };
  });

  // Call tool handler
  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    try {
      const { name, arguments: args } = request.params;

      switch (name) {
        case 'volcsearch_search': {
          const validated = SearchArgsSchema.parse(args);
          const result = await volcSearchClient.search(validated as SearchQuery);
          
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify(result, null, 2),
              },
            ],
            isError: false,
          };
        }

        case 'volcsearch_simple_search': {
          const validated = SimpleSearchArgsSchema.parse(args);
          const result = await volcSearchClient.simpleSearch(
            validated.index,
            validated.q,
            validated.size
          );
          
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify(result, null, 2),
              },
            ],
            isError: false,
          };
        }

        case 'volcsearch_match_search': {
          const validated = MatchSearchArgsSchema.parse(args);
          const result = await volcSearchClient.matchSearch(
            validated.index,
            validated.field,
            validated.query,
            validated.size
          );
          
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify(result, null, 2),
              },
            ],
            isError: false,
          };
        }

        case 'volcsearch_get_document': {
          const validated = GetDocumentArgsSchema.parse(args);
          const result = await volcSearchClient.getDocument(
            validated.index,
            validated.id
          );
          
          if (!result) {
            return {
              content: [
                {
                  type: 'text',
                  text: `Document with ID "${validated.id}" not found in index "${validated.index}"`,
                },
              ],
              isError: false,
            };
          }
          
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify(result, null, 2),
              },
            ],
            isError: false,
          };
        }

        case 'volcsearch_count': {
          const validated = CountArgsSchema.parse(args);
          const result = await volcSearchClient.count(
            validated.index,
            validated.query
          );
          
          return {
            content: [
              {
                type: 'text',
                text: `Total documents: ${result.count}`,
              },
            ],
            isError: false,
          };
        }

        default:
          return {
            content: [
              {
                type: 'text',
                text: `Unknown tool: ${name}`,
              },
            ],
            isError: true,
          };
      }
    } catch (error: any) {
      return {
        content: [
          {
            type: 'text',
            text: `Error: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  });

  // Start server with stdio transport
  const transport = new StdioServerTransport();
  await server.connect(transport);

  console.error('VolcSearch MCP server running on stdio');
}

main().catch((error) => {
  console.error('Server error:', error);
  process.exit(1);
});
