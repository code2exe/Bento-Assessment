module.exports = {
    apps : [
        {
          name: "bento-app",
          script: "./app/src/app.js",
          watch: true,
          env: {
              "PORT": 3000,
              "NODE_ENV": "development"
          },
          env_production: {
              "PORT": 8000,
              "NODE_ENV": "production",
          }
        }
    ]
  }