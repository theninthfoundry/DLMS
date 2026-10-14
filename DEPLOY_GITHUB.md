# 🚀 Deploying DLMS Strictly Through GitHub (GitHub Pages)

This project is configured to deploy **100% natively on GitHub** with **zero external hosting services** (no Render, Heroku, AWS, or third-party platforms required).

---

## 💡 How It Works Under the Hood

| Characteristic | Explanation |
| :--- | :--- |
| **Hosting Platform** | **GitHub Pages** (`https://<username>.github.io/<repo>/`) |
| **Architecture** | Client-Side MVC Web App with Browser Storage Engine (`docs/assets/js/db.js`) |
| **Database** | Relational in-browser database pre-loaded with complete dataset from `database.sql` (18 Books, 9 Patrons, 8 Transactions, 3 Fines, 3 Reservations) |
| **Interactivity** | Live Chart.js analytics, real-time issue/return validation, automatic fine calculation (₹5/day), FIFO waitlist queue, and instant CSV export |
| **Cost & Dependencies** | **100% Free**, zero credit card, zero external server maintenance |

---

## 🛠️ Step-by-Step Deployment Instructions

### Step 1: Push the Project to Your GitHub Repository
Run the following commands in your terminal if you haven't already pushed:

```bash
git add .
git commit -m "feat: Add GitHub Pages distribution and automated deploy workflow"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPOSITORY_NAME>.git
git push -u origin main
```

---

### Step 2: Enable GitHub Pages in Repository Settings
You can choose **either** of the following two methods:

#### 🌟 Method A: Using GitHub Actions (Recommended)
1. Open your repository on GitHub.
2. Click on the **⚙️ Settings** tab at the top.
3. In the left sidebar under *Code and automation*, click **Pages**.
4. Under **Build and deployment** -> **Source**, select:
   👉 **GitHub Actions**
5. That's it! The workflow defined in `.github/workflows/deploy-pages.yml` will automatically build and publish your site whenever you push to `main`.

#### 📁 Method B: Direct Deploy from `/docs` folder
1. Open your repository on GitHub.
2. Click on **⚙️ Settings** -> **Pages**.
3. Under **Build and deployment** -> **Source**, select:
   👉 **Deploy from a branch**
4. Under **Branch**, select **`main`** (or `master`) and choose the **`/docs`** folder from the dropdown.
5. Click **Save**.

---

### Step 3: Access Your Live Deployed System!
Within 60 to 90 seconds, your site will be live at:

```
https://<YOUR_USERNAME>.github.io/<YOUR_REPOSITORY_NAME>/
```

---

## 🔑 Demo Credentials for Evaluation / Viva

| Portal | Username | Password | Role & Permissions |
| :--- | :--- | :--- | :--- |
| **Admin Console** | `admin` | `admin123` | Full administrative control, issue/return books, catalog management, fine collection, and CSV audit exports |
| **Student Portal** | `siddhartha` | `student123` | Patron borrowing dashboard, due date countdowns, catalog search, and FIFO waitlist reservations |

*(Tip: Both login pages include 1-click **"Admin Demo"** and **"Student Demo"** buttons for instant testing during viva presentations).*

---

## 🔄 Examiner Data Reset
If test transactions or changes need to be reverted back to the pristine initial state during testing, simply click the **"Reset Data"** button located in the sidebar footer or homepage.
