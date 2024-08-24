# パラメータの定義
param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$true)]
    [string]$WsdFileName
)

# PlantUMLのjarファイルのパス
$PLANTUML_JAR = "E:\src\PlantUML\plantuml-1.2024.6.jar"

# ディレクトリパスの設定
$BASE_DIR = $PSScriptRoot
$WSD_DIR = Join-Path $BASE_DIR "$ProjectName/wsd"
$IMAGE_DIR = Join-Path $BASE_DIR "$ProjectName/images"

# WSDファイルのフルパス
$WSD_FILE = Join-Path $WSD_DIR "$WsdFileName.wsd"

# 出力する画像ファイル名
$IMAGE_FILE = Join-Path $IMAGE_DIR "$WsdFileName.png"

# WSDファイルの存在確認
if (-not (Test-Path $WSD_FILE)) {
    Write-Error "Error: WSD file not found: $WSD_FILE"
    exit 1
}

# 画像の生成
Write-Host "Generating diagram from $WSD_FILE"
java -jar $PLANTUML_JAR -charset UTF-8 -tpng $WSD_FILE -o $IMAGE_DIR -verbose

# 画像生成の確認
if (-not (Test-Path $IMAGE_FILE)) {
    Write-Error "Error: Failed to generate image file: $IMAGE_FILE"
    exit 1
}

# Gitの操作
Write-Host "Syncing with Git repository"

git add -u $BASE_DIR/
git commit -m "Update files change in Documents dir."
git push

Write-Host "Diagram sync completed successfully"