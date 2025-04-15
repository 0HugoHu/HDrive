@echo off
REM build.bat: Build frontend, move to public, build backend, push to Git

cd /d %~dp0frontend

echo [2/6] Installing frontend dependencies via pnpm...
call pnpm install

if %errorlevel% neq 0 (
    echo Failed to install frontend dependencies. Aborting.
    exit /b %errorlevel%
)

echo [3/6] Building frontend...
call pnpm run build

if %errorlevel% neq 0 (
    echo Frontend build failed. Aborting.
    exit /b %errorlevel%
)

echo [4/6] Copying built dist/ to public/dist...
cd ..
if exist public\dist (
    echo Removing old public/dist...
    rmdir /s /q public\dist
)
echo Copying frontend\dist to public\dist...
xcopy /e /i /y frontend\dist public\dist >nul

echo [5/6] Building Go backend to dist\hdrive...
set appName=hdrive
set buildDir=dist
mkdir %buildDir% >nul 2>&1

go build -o %buildDir%\%appName% -ldflags="-w -s" -tags=jsoniter .

echo [6/6] Committing and pushing to Git...
git add %buildDir%\%appName%
git commit -m "build: update compiled binary for %appName%"
git push

echo All build steps completed successfully.
pause
