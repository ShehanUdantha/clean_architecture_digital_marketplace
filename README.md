# Clean Architecture Flutter E-Commerce App

## Project Setup

Before you run the project, make sure to follow the steps below to properly set up the environment, generate necessary files, and run the tests.

### 1. Setup the `.env` file

You need to set up the `.env` file in the root directory of the project with your environment-specific variables.

#### Example:

Create a `.env` file in the root directory and include the following keys (replace with your values):

`STRIPE_TEST_PUBLISHABLE_KEY=your_publishable_key`

</br>

`STRIPE_TEST_SECRET_KEY=your_secret_key`

### 2. Generate Required Files

Run the following command to generate the necessary files (e.g., mocks, code related to the environment variables):

`dart run build_runner build`

### 3. (Optional) Configure Firebase Service Account for Push Notifications

If you wish to enable push notifications, you need to configure the 'firebaseServiceAccountJson' used in the project.

All setup instructions are included directly in the file:

`core/constants/firebase_values.dart`

Make sure to follow the comments inside that file to generate and insert your Firebase service account values correctly.

</br>

## Features

User View

- View Products
- Search Products
- Add Products to Cart
- Purchase Products
- Add to Favorites
- View Purchase History
- Download Purchased Products
- View Notifications
- Change Theme
- Change Language

Admin View

- Access Admin Dashboard
- Manage Products
- Manage Categories
- Manage Users
- Manage Notifications
- Change Theme
- Change Language

## Screenshots

#### Auth View

<p float="left">
<img src="./screenshots/sign_in.jpg" width="250" />
<img src="./screenshots/sign_up.jpg" width="250" />
<img src="./screenshots/email_verify.jpg" width="250" />
<img src="./screenshots/forgot_password.jpg" width="250" />
<img src="./screenshots/email_reset.jpg" width="250" />
</p>

#### User View

<p float="left">
<img src="./screenshots/user_home.jpg" width="250" />
<img src="./screenshots/search_product.jpg" width="250" />
<img src="./screenshots/view_all_product.jpg" width="250" />
<img src="./screenshots/product_view_1.jpg" width="250" />
<img src="./screenshots/product_view_2.jpg" width="250" />
<img src="./screenshots/empty_cart.jpg" width="250" />
<img src="./screenshots/cart.jpg" width="250" />
<img src="./screenshots/payment.jpg" width="250" />
<img src="./screenshots/purchase_history.jpg" width="250" />
<img src="./screenshots/purchase_products.jpg" width="250" />
<img src="./screenshots/notifications.jpg" width="250" />
<img src="./screenshots/user_profile.jpg" width="250" />
<img src="./screenshots/settings.jpg" width="250" />
</p>

#### Admin View

<p float="left">
<img src="./screenshots/admin_dashboard.jpg" width="250" />
<img src="./screenshots/admin_tools.jpg" width="250" />
<img src="./screenshots/product_manage.jpg" width="250" />
<img src="./screenshots/product_add.jpg" width="250" />
<img src="./screenshots/category_manage.jpg" width="250" />
<img src="./screenshots/users_manage.jpg" width="250" />
<img src="./screenshots/notification_manage.jpg" width="250" />
<img src="./screenshots/admin_profile.jpg" width="250" />
</p>

</br>

All product images used in this app are for educational purposes only.
