#!/usr/bin/env python3
"""
Script to fix corrupted flag icons by re-downloading from a reliable source
"""

import os
import json
import requests
from pathlib import Path
import shutil

# Currency code to country code mapping
CURRENCY_TO_COUNTRY = {
    "USD": "us",
    "EUR": "eu", 
    "GBP": "gb",
    "JPY": "jp",
    "CNY": "cn",
    "HKD": "hk",
    "AUD": "au",
    "CAD": "ca",
    "CHF": "ch",
    "INR": "in",
    "KRW": "kr",
    "SGD": "sg",
    "NZD": "nz",
    "SEK": "se",
    "NOK": "no",
    "DKK": "dk",
    "PLN": "pl",
    "THB": "th",
    "MYR": "my",
    "IDR": "id",
    "PHP": "ph",
    "VND": "vn",
    "BRL": "br",
    "MXN": "mx",
    "ZAR": "za",
    "RUB": "ru",
    "TRY": "tr",
    "AED": "ae",
    "SAR": "sa",
}

ASSETS_PATH = Path("Tips/Assets.xcassets")

def is_valid_png(file_path):
    """Check if file is a valid PNG"""
    try:
        with open(file_path, 'rb') as f:
            header = f.read(4)
            return header == b'\x89PNG'
    except:
        return False

def download_flag_from_flagpedia(currency_code: str, country_code: str) -> bytes:
    """Download flag from flagpedia.net"""
    url = f"https://flagpedia.net/data/flags/w580/{country_code}.png"
    try:
        response = requests.get(url, timeout=15, headers={
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        }, allow_redirects=True)
        if response.status_code == 200:
            # Verify it's a PNG
            if response.content[:4] == b'\x89PNG':
                return response.content
    except Exception as e:
        print(f"  Error downloading from flagpedia: {e}")
    return None

def download_flag_from_restcountries(currency_code: str, country_code: str) -> bytes:
    """Download flag from restcountries.eu (alternative)"""
    # For EU, use a different approach
    if country_code == "eu":
        url = "https://flagpedia.net/data/flags/w580/eu.png"
    else:
        url = f"https://flagpedia.net/data/flags/w580/{country_code}.png"
    
    try:
        response = requests.get(url, timeout=15, headers={
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        })
        if response.status_code == 200 and response.content[:4] == b'\x89PNG':
            return response.content
    except:
        pass
    return None

def fix_flag_icon(currency_code: str):
    """Fix a single flag icon"""
    country_code = CURRENCY_TO_COUNTRY.get(currency_code)
    if not country_code:
        print(f"✗ No country code mapping for {currency_code}")
        return False
    
    imageset_path = ASSETS_PATH / f"{currency_code.lower()}_icon.imageset"
    png_path = imageset_path / f"{currency_code.lower()}.png"
    
    if not imageset_path.exists():
        print(f"✗ Imageset not found for {currency_code}")
        return False
    
    # Try to download from multiple sources
    flag_data = None
    
    # Try flagpedia first
    flag_data = download_flag_from_flagpedia(currency_code, country_code)
    
    # If that fails, try alternative
    if not flag_data:
        flag_data = download_flag_from_restcountries(currency_code, country_code)
    
    if flag_data:
        # Backup old file if it exists
        if png_path.exists():
            backup_path = png_path.with_suffix('.png.backup')
            shutil.copy2(png_path, backup_path)
        
        # Write new PNG
        with open(png_path, 'wb') as f:
            f.write(flag_data)
        
        # Verify it's valid
        if is_valid_png(png_path):
            print(f"✓ Fixed flag for {currency_code} ({country_code})")
            # Remove backup
            backup_path = png_path.with_suffix('.png.backup')
            if backup_path.exists():
                backup_path.unlink()
            return True
        else:
            print(f"✗ Downloaded file for {currency_code} is not a valid PNG")
            # Restore backup
            backup_path = png_path.with_suffix('.png.backup')
            if backup_path.exists():
                shutil.copy2(backup_path, png_path)
                backup_path.unlink()
            return False
    else:
        print(f"✗ Failed to download flag for {currency_code}")
        return False

def main():
    """Main function"""
    print("Fixing corrupted flag icons...")
    print("=" * 50)
    
    fixed = 0
    failed = 0
    
    for currency_code in CURRENCY_TO_COUNTRY.keys():
        if fix_flag_icon(currency_code):
            fixed += 1
        else:
            failed += 1
    
    print("=" * 50)
    print(f"✅ Fixed {fixed} flags")
    if failed > 0:
        print(f"⚠️  Failed to fix {failed} flags")

if __name__ == "__main__":
    main()

