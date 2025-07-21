# knn_example.py
import numpy as np
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report, accuracy_score

# 1. Load dataset
iris = load_iris()
X, y = iris.data, iris.target

# 2. Split into train/test
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# 3. Feature scaling (important for KNN!)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 4. Create KNN model
k = 5  # number of neighbors
knn = KNeighborsClassifier(n_neighbors=k)

# 5. Train the model
knn.fit(X_train_scaled, y_train)

# 6. Predict
y_pred = knn.predict(X_test_scaled)

# 7. Evaluate
print("Accuracy:", accuracy_score(y_test, y_pred))
print("\nClassification report:\n", classification_report(y_test, y_pred))

# 8. Try predicting new data
sample = np.array([[5.0, 3.4, 1.6, 0.4]])  # some example measurements
sample_scaled = scaler.transform(sample)
predicted_class = knn.predict(sample_scaled)
print("\nPredicted class:", iris.target_names[predicted_class][0])
