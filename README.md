# 💸 Finance App

A modern personal finance tracker built using **Flutter**, allowing users to manage their income, expenses, and accounts with ease. This app is integrated with a Node.js backend called [`api-finance`](https://github.com/achfairuz/api-finance), using RESTful API endpoints to perform all financial operations.

> 🔗 Frontend: https://github.com/achfairuz/finance  
> 🔗 Backend: https://github.com/achfairuz/api-finance

---

## 📱 Features

- ✅ User authentication (login, session handling)
- ✅ Add/edit/delete transactions
- ✅ Track income and expenses
- ✅ Monthly and yearly chart visualization (powered by `fl_chart`)
- ✅ Account management (Rekening)
- ✅ Data fetched via secure REST API
- ✅ Responsive UI design

---

## 🔧 Technologies Used

### Flutter (Frontend)
- Dart language
- `http` for REST API communication
- `fl_chart` for charts
- `shared_preferences` for local session storage

### Express.js (Backend)
- RESTful API with JWT authentication
- MySQL/PostgreSQL database
- Node.js with Sequelize ORM
- CORS and secure headers

---

## 🛠️ Getting Started

### 📦 Clone the repositories

```bash
# Clone the Flutter frontend
gh repo clone achfairuz/finance

# Clone the backend API
gh repo clone achfairuz/api-finance
```

### ▶️ Run the Flutter App

```bash
cd finance
flutter pub get
flutter run
```

Make sure a device or emulator is connected.

### 🖥️ Run the Backend API

```bash
cd api-finance
npm install
npm run dev
```

Make sure to configure the `.env` file with your database credentials.

---

## 📁 Project Structure (Flutter)

```
lib/
├── UI/
│   ├── home/
│   └── components/
├── core/
│   ├── constants/
│   ├── models/
│   ├── services/
│   └── utils/
├── data/
│   └── data_sources/
└── main.dart
```

---

## 📊 Chart Visualizations

- Monthly overview of income and expenses
- Grouped by year and category
- Real-time updates when data changes

---

## 🔐 API Integration

All financial operations such as adding transactions, fetching account balances, and generating reports are handled via the [`api-finance`](https://github.com/achfairuz/api-finance) backend.

API Base URL is set in the `core/constants/constants.dart` file.

---

## 📇 Author

- 💼 **Achmad Fairuz**  
  📧 [fairf717@gmail.com](mailto:fairf717@gmail.com)  
  🌐 GitHub: [github.com/achfairuz](https://github.com/achfairuz)  
  🔗 LinkedIn: [linkedin.com/in/achmad-fairuz-27521b24b](https://www.linkedin.com/in/achmad-fairuz-27521b24b/)

---

## 📃 License

This project is licensed under the MIT License.