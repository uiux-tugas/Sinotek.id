# Simple HTTP Server using PowerShell
$port = 8000
$path = "c:\Users\ACER\Documents\Tugas\uiux"

Write-Host "Starting HTTP server on port $port..."
Write-Host "Access at: http://localhost:$port"
Write-Host "Press Ctrl+C to stop"

try {
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$port/")
    $listener.Start()

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $localPath = $request.Url.LocalPath
        if ($localPath -eq "/" -or $localPath -eq "") {
            $localPath = "/index.html"
        }

        $filePath = Join-Path $path $localPath.TrimStart("/")

        if (Test-Path $filePath -PathType Leaf) {
            $content = Get-Content $filePath -Raw -Encoding UTF8
            $response.ContentType = "text/html; charset=utf-8"
            $response.StatusCode = 200
        } else {
            $content = "<h1>404 - File Not Found</h1><p>File: $localPath</p>"
            $response.StatusCode = 404
        }

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }
} catch {
    Write-Host "Error: $_"
} finally {
    if ($listener) {
        $listener.Stop()
    }
}