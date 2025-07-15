/** @type {import('next').NextConfig} */
module.exports = {
  async rewrites() {
    // Only rewrite in local dev so you can `npm run dev`
    if (process.env.NODE_ENV === 'development') {
      return [
        {
          source: '/api/:path*',
          destination: 'http://127.0.0.1:8000/api/:path*',
        },
      ];
    }
    // In any docker / prod build we do NO rewrites
    return [];
  },
};

