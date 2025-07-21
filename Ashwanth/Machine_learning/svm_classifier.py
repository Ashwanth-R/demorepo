# svm_example.py
import numpy as np
from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report

# 1. Load dataset
wine = load_wine()
X, y = wine.data, wine.target

# 2. Split into train and test sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# 3. Feature scaling (important for SVM!)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 4. Create SVM classifier
svm_clf = SVC(kernel='rbf', C=1.0, gamma='scale', random_state=42)

# 5. Train the classifier
svm_clf.fit(X_train_scaled, y_train)

# 6. Make predictions
y_pred = svm_clf.predict(X_test_scaled)

# 7. Evaluate
print("Accuracy:", accuracy_score(y_test, y_pred))
print("\nClassification report:\n", classification_report(y_test, y_pred))

# 8. Predict new sample
sample = np.array([[13.2, 2.7, 2.5, 18.0, 100.0, 2.8, 3.0, 0.3, 2.1, 5.0, 1.0, 3.0, 1000]])
sample_scaled = scaler.transform(sample)
predicted_class = svm_clf.predict(sample_scaled)
print("\nPredicted class:", wine.target_names[predicted_class][0])
