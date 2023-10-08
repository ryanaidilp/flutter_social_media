# Flutter Social Media Installation Instructions

Before you begin, ensure you have Flutter version 3.13.6 installed on your system.

1. **Clone the Repository:**

   ```
   git clone <repository_url>
   ```

2. **Configure Environment Variables:**

   - Copy the `example.env` file and rename it to `.env`.
   - Edit the `.env` file and set the API BASE URL as follows:
     ```
     API_BASE_URL=https://banuatest.xyz
     ```

3. **Install Dependencies:**

   ```
   flutter pub get
   ```

4. **Generate Code:**

   ```
   flutter pub run build_runner build
   ```

5. **Launch the App:**
   - In Visual Studio Code, navigate to the run section and select the appropriate flavor (development, staging, or production) from the dropdown menu.
   - Alternatively, you can launch the app using the following command:
     ```
     flutter pub run -t lib/main.dart --flavor <Flavor of your choice>
     ```

Now you're all set! Enjoy using the app. If you encounter any issues, feel free to reach out for assistance.
