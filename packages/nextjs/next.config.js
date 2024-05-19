const isProd = process.env.NODE_ENV === 'production';

module.exports = {
  reactStrictMode: true,
  metadata: {
    metadataBase: new URL(isProd ? 'https://yourdomain.com' : 'http://localhost:3000'),
  },
};
