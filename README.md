# Express Rest API

REST API package for Express.js. Get full CRUD with filtering, sorting, pagination, validation, and hooks — in minutes.

[![npm version](https://img.shields.io/npm/v/@rkumwt/express-rest-api)](https://www.npmjs.com/package/@rkumwt/express-rest-api)
[![license](https://img.shields.io/npm/l/@rkumwt/express-rest-api)](https://github.com/rkumwt/rest-api/blob/master/LICENSE)

**Documentation:** [https://express-rest-api.rajesh-kumawat.in](https://express-rest-api.rajesh-kumawat.in)

## Features

- **Zero boilerplate CRUD** — Define a controller, get 6 REST endpoints
- **Filtering, sorting, pagination** — Built-in query parameter parsing
- **Default adapter** — Configure once, use in every controller
- **Multi-ORM support** — Prisma, Sequelize, Mongoose, Knex, Drizzle
- **Lifecycle hooks** — beforeStore, afterStore, beforeUpdate, etc.
- **Validation** — Zod, Joi, or custom functions (auto-detected)
- **Hidden fields** — Automatically strip sensitive data from responses

## Installation

```bash
npm install @rkumwt/express-rest-api
```

Install your ORM of choice:

```bash
npm install @prisma/client    # Prisma
npm install sequelize          # Sequelize
npm install mongoose           # Mongoose
npm install knex               # Knex
npm install drizzle-orm        # Drizzle
```

## Quick Start (Step by Step)

This guide uses **Prisma + SQLite**. The steps are the same for any ORM — only the adapter changes.

### 1. Set up Prisma

```bash
npm install express @prisma/client
npm install -D prisma
```

Create `prisma/schema.prisma`:

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = "file:./dev.db"
}

model User {
  id        Int      @id @default(autoincrement())
  name      String
  email     String   @unique
  role      String   @default("user")
  createdAt DateTime @default(now())
}
```

Push the schema to create your database:

```bash
npx prisma db push
```

### 2. Create Config Files

```js
// config/database.js — Database connection (shared singleton)
const { PrismaClient } = require('@prisma/client');
const db = new PrismaClient();
module.exports = db;
```

```js
// config/api.js — Set the adapter factory once for all controllers
const { configure, createPrismaAdapter } = require('@rkumwt/express-rest-api');

configure({
  adapter: createPrismaAdapter,
});
```

### 3. Create a Controller

```js
// controllers/UserController.js
const { ApiController } = require('@rkumwt/express-rest-api');
const db = require('../config/database');

class UserController extends ApiController {
  // Adapter is auto-created from the factory set in config/api.js
  model = db.user;

  // Fields returned by default when client doesn't specify ?fields=
  defaultFields = ['id', 'name', 'email', 'role', 'createdAt'];

  // Fields allowed in ?filters=
  filterableFields = ['id', 'name', 'email', 'role'];

  // Fields allowed in ?order=
  sortableFields = ['id', 'name', 'email', 'createdAt'];
}

module.exports = UserController;
```

### 4. Register Routes

```js
// routes/api.js
const { createApiRouter } = require('@rkumwt/express-rest-api');
const UserController = require('../controllers/UserController');

const api = createApiRouter({ prefix: '/api', version: 'v1' });

// Registers: GET, POST /api/v1/users + GET, PUT, PATCH, DELETE /api/v1/users/:id
api.apiResource('users', UserController);

module.exports = api;
```

### 5. Set up Express

```js
// server.js
const express = require('express');
const { apiErrorHandler } = require('@rkumwt/express-rest-api');

require('./config/api'); // Load adapter + global settings
const api = require('./routes/api');

const app = express();

app.use(express.json());
app.use(api.getRouter());
app.use(apiErrorHandler); // Handles 404, validation, and other API errors

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
```

### 6. Test It

```bash
node server.js
```

```bash
# Create a user
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "email": "john@example.com"}'

# List all users
curl http://localhost:3000/api/v1/users

# Get a single user
curl http://localhost:3000/api/v1/users/1

# Update a user
curl -X PUT http://localhost:3000/api/v1/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe"}'

# Delete a user
curl -X DELETE http://localhost:3000/api/v1/users/1
```

That's it! You have a full REST API with filtering, sorting, and pagination built in.

## Query Parameters

```bash
# Select specific fields
GET /api/v1/users?fields=id,name,email

# Include relations
GET /api/v1/users?fields=id,name,posts{id,title}

# Filter
GET /api/v1/users?filters=(role eq admin)
GET /api/v1/users?filters=(role eq admin and status eq active)
GET /api/v1/users?filters=(name lk john)

# Sort
GET /api/v1/users?order=name asc
GET /api/v1/users?order=name asc, id desc

# Paginate
GET /api/v1/users?limit=10&offset=20
```

**Filter operators:** `eq` `ne` `gt` `ge` `lt` `le` `lk`

## Response Format

```json
// GET /api/v1/users
{
  "data": [
    { "id": 1, "name": "John", "email": "john@example.com" }
  ],
  "meta": {
    "paging": {
      "total": 87,
      "limit": 10,
      "offset": 0,
      "previous": null,
      "next": "/api/v1/users?limit=10&offset=10"
    },
    "timing": "5ms"
  }
}

// GET /api/v1/users/1
{ "data": { "id": 1, "name": "John", "email": "john@example.com" } }

// POST /api/v1/users → 201
{ "data": { "id": 42, "name": "John" }, "message": "Resource created successfully" }

// DELETE /api/v1/users/1 → 200
{ "message": "Resource deleted successfully" }
```

## Switching Adapters

Change one line in config — all controllers stay the same:

```js
// Prisma
configure({ adapter: createPrismaAdapter });

// Sequelize
configure({ adapter: createSequelizeAdapter });

// Mongoose
configure({ adapter: createMongooseAdapter });
```

You can also set the adapter explicitly per controller (overrides config):

```js
class UserController extends ApiController {
  adapter = createPrismaAdapter(db.user); // Explicit — overrides config
}
```

## Documentation

Full documentation with examples, hooks, validation, and API reference:

**[https://express-rest-api.rajesh-kumawat.in](https://express-rest-api.rajesh-kumawat.in)**

## Support

If you find this package useful, please consider supporting it:

- **Star this repo** — It helps others discover the project
- **Fork it** — Contribute features, fixes, or improvements
- **Share it** — Tell other developers about it

**[GitHub Repository](https://github.com/rkumwt/rest-api)**

## License

MIT
