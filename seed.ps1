
# ============================================
# Python AI Engineering - Production Seeder
# ============================================

function Write-TextFile($Path, $Content) {
    $dir = Split-Path -Parent $Path
    if ($dir -and !(Test-Path $dir)) {
        New-Item -ItemType Directory -Force $dir | Out-Null
    }
    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

Write-Host "🚀 Seeding production-ready structure..."

# ---------------- README ----------------
Write-TextFile "README.md" @"
# Python AI Engineering Practice

Production-ready AI engineering sandbox.

## Quickstart (Windows)

py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python -m src.cli --mode train
"@

# ---------------- Requirements ----------------
Write-TextFile "requirements.txt" @"
pandas
numpy
scikit-learn
pyyaml
joblib
pytest
"@

# ---------------- CLI ----------------
Write-TextFile "src\cli.py" @"
from src.pipelines.training_pipeline import run_training

if __name__ == '__main__':
    run_training()
"@

# ---------------- Training Pipeline ----------------
Write-TextFile "src\pipelines\training_pipeline.py" @"
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import joblib
import os

def run_training():
    print('Starting baseline training...')

    iris = load_iris()
    X_train, X_test, y_train, y_test = train_test_split(
        iris.data, iris.target, test_size=0.2, random_state=42
    )

    model = LogisticRegression(max_iter=200)
    model.fit(X_train, y_train)

    preds = model.predict(X_test)
    acc = accuracy_score(y_test, preds)

    os.makedirs("models", exist_ok=True)
    joblib.dump(model, "models/baseline_model.joblib")

    print(f"Training complete. Accuracy: {acc}")
    print("Model saved to models/baseline_model.joblib")
"@

Write-Host "✅ Seed completed successfully."