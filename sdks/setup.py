#!/usr/bin/env python3
"""
Setup script for Agent Tokenization Python SDK
"""

from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="agent-tokenization-sdk",
    version="1.0.0",
    author="Agent Tokenization Platform",
    author_email="support@agent-tokenization.com",
    description="Python SDK for the Agent Tokenization platform",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/your-org/agent-tokenization-python-sdk",
    project_urls={
        "Bug Tracker": "https://github.com/your-org/agent-tokenization-python-sdk/issues",
        "Documentation": "https://docs.agent-tokenization.com/python-sdk",
        "Source Code": "https://github.com/your-org/agent-tokenization-python-sdk",
    },
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Internet :: WWW/HTTP :: HTTP Servers",
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
    ],
    package_dir={"": "."},
    py_modules=["agent_tokenization_sdk"],
    python_requires=">=3.7",
    install_requires=[
        "requests>=2.25.0",
        "dataclasses;python_version<'3.7'",
    ],
    extras_require={
        "dev": [
            "pytest>=6.0.0",
            "pytest-asyncio>=0.15.0",
            "black>=21.0.0",
            "isort>=5.0.0",
            "flake8>=3.8.0",
            "mypy>=0.910",
            "coverage>=5.5",
        ],
        "async": [
            "aiohttp>=3.8.0",
            "asyncio",
        ],
        "flask": [
            "Flask>=2.0.0",
        ],
        "django": [
            "Django>=3.2.0",
        ],
        "fastapi": [
            "fastapi>=0.68.0",
            "uvicorn>=0.15.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "agent-tokenization-cli=agent_tokenization_sdk:main",
        ],
    },
    keywords=[
        "agent-tokenization", 
        "daml", 
        "blockchain", 
        "ai-agents", 
        "usage-tracking", 
        "smart-contracts",
        "python-sdk"
    ],
    zip_safe=False,
)