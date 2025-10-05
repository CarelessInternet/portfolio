import { defineConfig, envField } from 'astro/config';
import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
	adapter: node({ mode: 'standalone' }),
	env: {
		schema: {
			UMAMI_URL: envField.string({
				context: 'client',
				access: 'public',
				url: true,
				optional: true
			}),
			UMAMI_ID: envField.string({
				context: 'client',
				access: 'public',
				optional: true
			})
		}
	}
});
