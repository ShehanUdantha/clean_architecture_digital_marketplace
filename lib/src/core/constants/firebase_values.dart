const firebaseMessagingScope = [
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/firebase.database",
  "https://www.googleapis.com/auth/firebase.messaging",
];

// ! IMPORTANT: Please update the "firebaseServiceAccountJson" values with your Firebase service account details.
// Follow these steps to generate and configure the required values:
// 1. Go to your Firebase Project Console: https://console.firebase.google.com
// 2. Navigate to "Project Settings" -> "Service Accounts" tab.
// 3. Click "Generate New Private Key" to download the JSON file for your service account.
// 4. Open the downloaded JSON file and copy its contents.
// 5. Replace the placeholders (e.g., "private_key_id", "private_key", etc.) in this map with the corresponding values from the JSON file.

// Example:
// {
//   "type": "service_account",
//   "project_id": "your_project_id",
//   "private_key_id": "your_private_key_id",
//   "private_key": "your_private_key",
//   "client_email": "your_client_email",
//   "client_id": "your_client_id",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "your_client_x509_cert_url",
//   "universe_domain": "googleapis.com"
// }

final firebaseServiceAccountJson = {
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "",
  "client_email": "",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "",
  "universe_domain": "googleapis.com"
};
