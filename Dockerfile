# Use a Windows Server Core image with Python 3.9
FROM winamd64/python:3

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
RUN git clone https://github.com/thermofisherlsms/RawFileReader.git C:\\data\\RawFileReader
RUN git clone https://github.com/mtinti/win_raw_qc.git C:\\data\\raw_qc

# Set the working directory
WORKDIR C:/data

# Set the entry point to run your script
# ENTRYPOINT ["python", "C:\\data\\win_raw_qc\\make_qc.py"]
