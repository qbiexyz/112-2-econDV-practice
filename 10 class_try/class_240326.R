
library(reticulate)


# 找電腦Python路径
py_config()

# 使用指定的Python路径
use_python("C:/Users/qbieq/Documents/.virtualenvs/r-reticulate/Scripts/python.exe", required = TRUE)

# 創造虛擬環境
virtualenv_create("econDV")

# 使用虛擬環境
use_virtualenv("econDV", required = TRUE)

# 安裝openai套件
py_install("openai", envname = "DataVisualization")

# Load the Python script
source_python("python_script.py")

# Call the Python function
response <- describeGraph("https://tpemartin.github.io/112-2-econDV/20181020_WOC443_0.jpeg")


