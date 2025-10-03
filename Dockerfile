# https://docs.astro.build/en/recipes/docker/#multi-stage-build-using-ssr

ARG BUN_MAJOR_VERSION=1

FROM oven/bun:${BUN_MAJOR_VERSION}-alpine as base
WORKDIR /app

# By copying only the package.json and package-lock.json here, we ensure that the following `-deps` steps are independent of the source code.
# Therefore, the `-deps` steps will be skipped if only the source code changes.
COPY package.json package-lock.json ./

FROM base AS prod-deps
RUN bun install --omit=dev

FROM base AS build-deps
RUN bun install

FROM build-deps AS build
COPY . .
RUN bun run build

FROM base AS runtime
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD node ./dist/server/entry.mjs
