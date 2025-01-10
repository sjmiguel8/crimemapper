#!/bin/bash

# Clean and get dependencies
flutter clean
flutter pub get

# Build the web app
flutter build web --release --web-renderer canvaskit --base-href /

# Deploy to S3
aws s3 sync build/web/ s3://crimemapper/ --delete

echo "Deployment complete! Your app should be available at http://crimemapper.s3-website-us-east-1.amazonaws.com"

# Optional: Invalidate CloudFront cache if you're using CDN
# aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*" 