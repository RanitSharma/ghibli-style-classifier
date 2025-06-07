## Project: AI Ghibli Style Accuracy Classification
## Author: Ranit Sharma and Vamsi K Murali
## Date: 4/21/2025

# Load required libraries
library(caret)
library(rpart)
library(rpart.plot)
library(klaR)
library(rsample)
library(naivebayes)
library(ggplot2)

# Set seed and load data
setwd("C:/Users/ranit/OneDrive/Desktop/Data101")
set.seed(1234)
data <- read.csv("ai_ghibli_trend_dataset_v2.csv")

# Create target class variable (Low, Medium, High)
data$accuracy_class <- cut(data$style_accuracy_score,
                           breaks=c(-Inf, 60, 80, Inf),
                           labels=c("Low", "Medium", "High"))
data$accuracy_class <- factor(data$accuracy_class)

# Convert necessary columns to factors
data$platform <- factor(data$platform)
data$is_hand_edited <- factor(data$is_hand_edited)
data$ethical_concerns_flag <- factor(data$ethical_concerns_flag)

# Drop unnecessary columns
data <- subset(data, select = -c(image_id, user_id, prompt, resolution, creation_date, top_comment, style_accuracy_score))
data <- na.omit(data)

# ------------------ Exploratory Data Analysis ------------------
# Barplot of target classes
ggplot(data, aes(x = accuracy_class)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Distribution of Accuracy Classes", x = "Accuracy Class", y = "Count")

# Boxplot of generation time vs accuracy class
ggplot(data, aes(x = accuracy_class, y = generation_time)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Generation Time by Accuracy Class", x = "Accuracy Class", y = "Generation Time (s)")

# Relationship between platform and accuracy class
ggplot(data, aes(x = platform, fill = accuracy_class)) +
  geom_bar(position = "dodge") +
  labs(title = "Platform vs Accuracy Class", x = "Platform", y = "Count")

# ------------------ Train/Test Split ------------------
data <- data[sample(nrow(data)), ]
split <- initial_split(data, prop = 0.75)
training_data <- training(split)
test_data <- testing(split)

# Ensure test set has same factor levels as training
for (col in colnames(training_data)) {
  if (is.factor(training_data[[col]])) {
    test_data[[col]] <- factor(test_data[[col]], levels = levels(training_data[[col]]))
  }
}

# ------------------ Decision Tree ------------------
tree_model <- rpart(accuracy_class ~ ., data = training_data, method = "class", control = rpart.control(cp = 0.001))
rpart.plot(tree_model)
tree_pred <- predict(tree_model, test_data, type = "class")
conf_matrix_tree <- table(tree_pred, test_data$accuracy_class)
caret::confusionMatrix(conf_matrix_tree)

# ------------------ Naive Bayes ------------------
nb_model <- NaiveBayes(accuracy_class ~ ., data = training_data)
nb_pred <- predict(nb_model, test_data)
conf_matrix_nb <- table(nb_pred$class, test_data$accuracy_class)
caret::confusionMatrix(conf_matrix_nb)

# ------------------ Cross Validation ------------------
control <- trainControl(method="cv", number=10, savePredictions = TRUE)
cv_tree <- train(accuracy_class ~ ., data=training_data, method="rpart", trControl=control)
print(cv_tree)

cv_nb <- train(accuracy_class ~ ., data=training_data, method="naive_bayes", trControl=control)
print(cv_nb)

# ------------------ Pruned Tree ------------------
best_cp <- cv_tree$results[which.max(cv_tree$results$Accuracy), "cp"]
pruned_tree <- rpart(accuracy_class ~ ., data=training_data, method="class", control=rpart.control(cp = best_cp))
rpart.plot(pruned_tree)

pruned_pred <- predict(pruned_tree, test_data, type = "class")
conf_matrix_pruned <- table(pruned_pred, test_data$accuracy_class)
caret::confusionMatrix(conf_matrix_pruned)
