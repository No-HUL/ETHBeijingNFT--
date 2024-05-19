// next.config.js

const isProd = process.env.NODE_ENV === 'production';

module.exports = {
  experimental: {
    appDir: true, // 确保启用了 experimental app directory
  },
  reactStrictMode: true,
  metadata: {
    metadataBase: new URL(isProd ? 'https://yourdomain.com' : 'http://localhost:3000'),
  },
};
