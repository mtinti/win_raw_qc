# Use a Windows Server Core image with Python 3.9
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install Python 3.9
ADD https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe C:\\TEMP\\python-installer.exe
RUN C:\\TEMP\\python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 && del C:\\TEMP\\python-installer.exe

# Install Chocolatey - package manager
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install wget, git and other necessary tools
RUN choco install wget git -y

# Install .NET Core SDK
RUN choco install dotnet-sdk -y

# Install Mono
RUN choco install mono -y

# Install Python requirements
COPY requirements.txt C:/data/
RUN pip install --no-cache-dir -r C:/data/requirements.txt

# Clone repositories
RUN git clone https://github.com/thermofisherlsms/RawFileReader.git C:\\data\\RawFileReader \
    && git clone https://github.com/mtinti/raw_qc.git C:\\data\\raw_qc

# Set the working directory
WORKDIR C:/data

# Set the entry point to run your script
ENTRYPOINT ["python", "C:\\data\\raw_qc\\make_qc.py"]
