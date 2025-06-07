# 🎨 AI-Generated Ghibli Style Classifier

This project explores machine learning classification methods in R to predict how closely AI-generated images resemble the visual style of **Studio Ghibli**. We used the **"AI Generated Ghibli Style Image Trends (2025)"** dataset, which contains metadata for 500 AI-generated images and includes features like generation time, platform, and user engagement.

## 👥 Team Members
- **Ranit Sharma** – R coding (preprocessing, modeling, evaluation)
- **Vamsi Krishna Murali** – EDA visualizations and report writing

---

## 📊 Dataset
- **Source**: [Kaggle - Ghibli Style AI Image Trends (2025)](https://www.kaggle.com/datasets/uom190346a/ai-generated-ghibli-style-image-trends-2025?resource=download)
- **Size**: 500 AI-generated images with metadata
- **Target Variable**: `style_accuracy_score` (transformed into categories: Low, Medium, High)
- **Features**: likes, generation time, platform, shares, GPU usage, editing status, etc.

---

## ⚙️ Methods

- Cleaned and preprocessed data in R, removing irrelevant/unstructured columns
- Converted continuous style scores into categorical labels:
  - **Low** (0–60), **Medium** (61–80), **High** (81–100)
- Split data (75% training / 25% testing) using `rsample::initial_split()`
- Built and evaluated two classification models:
  - **Decision Tree** using `rpart()` and `caret::train()` with 10-fold cross-validation
  - **Naive Bayes** using `klaR::NaiveBayes()`
- Evaluated using accuracy and confusion matrices

---

## 📈 Results

| Model         | Accuracy | Best Class Handling        |
|---------------|----------|----------------------------|
| Decision Tree | **78.6%** | Best overall performance with balanced predictions |
| Naive Bayes   | 72.4%     | Struggled with minority class (Low) due to class imbalance |

📌 **Key predictors**:  
- `likes`  
- `generation_time`  
- `platform` (e.g. TikTok had highest quality scores)

---

## 📄 Project Report
Full details of methodology, visuals, and evaluation results:  
📎 [ghibli_project_report.pdf](./ghibli_project_report.pdf)

---

## 📜 R Script
All preprocessing, modeling, and evaluation are contained in:  
📁 [ghibli_classifier.R](./ghibli_classifier.R)

---

## 🧠 Skills Used
- R programming  
- Data wrangling & visualization (`ggplot2`)  
- Machine learning (`rpart`, `klaR`, `caret`)  
- Model evaluation & cross-validation  
- Scientific writing and team collaboration

---

## 📬 Contact
- Ranit Sharma – rs2402@scarletmail.rutgers.edu  
- Vamsi Krishna Murali – vkm35@scarletmail.rutgers.edu
