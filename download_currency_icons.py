#!/usr/bin/env python3
"""
Script to download currency icons and organize them into Xcode Assets.xcassets
"""

import os
import json
import requests
from pathlib import Path
from typing import Dict, Tuple

# Configuration
ASSETS_PATH = Path("Tips/Assets.xcassets")
ICON_SIZE = 64  # Standard icon size for currency icons

# Currency code to country code mapping for flags
CURRENCY_TO_COUNTRY: Dict[str, str] = {
    "USD": "us",  # United States
    "EUR": "eu",  # European Union (using EU flag)
    "GBP": "gb",  # United Kingdom
    "JPY": "jp",  # Japan
    "CNY": "cn",  # China
    "HKD": "hk",  # Hong Kong
    "AUD": "au",  # Australia
    "CAD": "ca",  # Canada
    "CHF": "ch",  # Switzerland
    "INR": "in",  # India
    "KRW": "kr",  # South Korea
    "SGD": "sg",  # Singapore
    "NZD": "nz",  # New Zealand
    "SEK": "se",  # Sweden
    "NOK": "no",  # Norway
    "DKK": "dk",  # Denmark
    "PLN": "pl",  # Poland
    "THB": "th",  # Thailand
    "MYR": "my",  # Malaysia
    "IDR": "id",  # Indonesia
    "PHP": "ph",  # Philippines
    "VND": "vn",  # Vietnam
    "BRL": "br",  # Brazil
    "MXN": "mx",  # Mexico
    "ZAR": "za",  # South Africa
    "RUB": "ru",  # Russia
    "TRY": "tr",  # Turkey
    "AED": "ae",  # United Arab Emirates
    "SAR": "sa",  # Saudi Arabia
}

# Crypto currencies with their icon URLs (using CoinGecko API)
CRYPTO_CURRENCIES: Dict[str, str] = {
    "BTC": "https://assets.coingecko.com/coins/images/1/small/bitcoin.png",
    "ETH": "https://assets.coingecko.com/coins/images/279/small/ethereum.png",
    "USDT": "https://assets.coingecko.com/coins/images/325/small/Tether.png",
    "BNB": "https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png",
    "USDC": "https://assets.coingecko.com/coins/images/6319/small/USD_Coin_icon.png",
    "XRP": "https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png",
    "ADA": "https://assets.coingecko.com/coins/images/975/small/cardano.png",
    "DOGE": "https://assets.coingecko.com/coins/images/5/small/dogecoin.png",
    "SOL": "https://assets.coingecko.com/coins/images/4128/small/solana.png",
    "MATIC": "https://assets.coingecko.com/coins/images/4713/small/matic-token-icon.png",
}

def create_imageset(currency_code: str, icon_path: Path, is_crypto: bool = False) -> None:
    """Create an imageset folder and Contents.json for a currency icon"""
    imageset_name = f"{currency_code.lower()}_icon.imageset"
    imageset_path = ASSETS_PATH / imageset_name
    
    # Create imageset directory
    imageset_path.mkdir(parents=True, exist_ok=True)
    
    # Copy icon to imageset
    icon_filename = f"{currency_code.lower()}.png"
    dest_icon_path = imageset_path / icon_filename
    
    # If icon_path exists and is a file, copy it
    if icon_path.exists() and icon_path.is_file():
        import shutil
        shutil.copy2(str(icon_path), str(dest_icon_path))
    else:
        print(f"Warning: Icon file not found at {icon_path}")
        return
    
    # Create Contents.json
    contents = {
        "images": [
            {
                "filename": icon_filename,
                "idiom": "universal",
                "scale": "1x"
            },
            {
                "idiom": "universal",
                "scale": "2x"
            },
            {
                "idiom": "universal",
                "scale": "3x"
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    contents_path = imageset_path / "Contents.json"
    with open(contents_path, "w") as f:
        json.dump(contents, f, indent=2)
    
    print(f"✓ Created imageset for {currency_code}")

def download_flag_icon(currency_code: str, country_code: str) -> Path:
    """Download a country flag icon"""
    # Try multiple flag APIs - flagpedia.net is most reliable
    urls = [
        f"https://flagpedia.net/data/flags/w580/{country_code}.png",
        f"https://flagcdn.com/{ICON_SIZE}x{ICON_SIZE}/{country_code}.png",
        f"https://flagcdn.com/w{ICON_SIZE}/{country_code}.png",
    ]
    
    temp_dir = Path("temp_icons")
    temp_dir.mkdir(exist_ok=True)
    icon_path = temp_dir / f"{currency_code.lower()}.png"
    
    for url in urls:
        try:
            response = requests.get(url, timeout=10, headers={
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
            }, allow_redirects=True)
            if response.status_code == 200:
                # Verify it's actually an image (not HTML)
                content_type = response.headers.get('Content-Type', '')
                if 'image' in content_type or response.content[:4] == b'\x89PNG':
                    with open(icon_path, "wb") as f:
                        f.write(response.content)
                    # Verify the file is actually a PNG
                    if icon_path.exists() and icon_path.stat().st_size > 100:
                        print(f"✓ Downloaded flag for {currency_code} ({country_code}) from {url.split('/')[2]}")
                        return icon_path
        except Exception as e:
            continue
    
    print(f"✗ Failed to download flag for {currency_code} from all sources")
    return Path()

def download_crypto_icon(currency_code: str, url: str) -> Path:
    """Download a crypto currency icon"""
    try:
        response = requests.get(url, timeout=10, headers={
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        })
        response.raise_for_status()
        
        # Verify it's actually an image
        content_type = response.headers.get('Content-Type', '')
        if 'image' not in content_type and response.content[:4] != b'\x89PNG':
            raise ValueError(f"Response is not an image, Content-Type: {content_type}")
        
        # Save to temp location
        temp_dir = Path("temp_icons")
        temp_dir.mkdir(exist_ok=True)
        
        icon_path = temp_dir / f"{currency_code.lower()}.png"
        with open(icon_path, "wb") as f:
            f.write(response.content)
        
        # Verify file was created and has content
        if icon_path.exists() and icon_path.stat().st_size > 100:
            print(f"✓ Downloaded crypto icon for {currency_code}")
            return icon_path
        else:
            raise ValueError("Downloaded file is too small or empty")
    except Exception as e:
        print(f"✗ Failed to download crypto icon for {currency_code}: {e}")
        return Path()

def main():
    """Main function to download and organize currency icons"""
    print("Starting currency icon download...")
    print("=" * 50)
    
    # Ensure Assets.xcassets exists
    ASSETS_PATH.mkdir(parents=True, exist_ok=True)
    
    # Create temp directory for downloaded icons
    temp_dir = Path("temp_icons")
    temp_dir.mkdir(exist_ok=True)
    
    # Download fiat currency flags
    print("\n📥 Downloading fiat currency flags...")
    fiat_icons = {}
    for currency, country in CURRENCY_TO_COUNTRY.items():
        icon_path = download_flag_icon(currency, country)
        if icon_path.exists():
            fiat_icons[currency] = icon_path
    
    # Download crypto currency icons
    print("\n📥 Downloading crypto currency icons...")
    crypto_icons = {}
    for currency, url in CRYPTO_CURRENCIES.items():
        icon_path = download_crypto_icon(currency, url)
        if icon_path.exists():
            crypto_icons[currency] = icon_path
    
    # Create imagesets for fiat currencies
    print("\n📦 Creating imagesets for fiat currencies...")
    for currency, icon_path in fiat_icons.items():
        create_imageset(currency, icon_path, is_crypto=False)
    
    # Create imagesets for crypto currencies
    print("\n📦 Creating imagesets for crypto currencies...")
    for currency, icon_path in crypto_icons.items():
        create_imageset(currency, icon_path, is_crypto=True)
    
    # Clean up temp directory
    print("\n🧹 Cleaning up temporary files...")
    import shutil
    if temp_dir.exists():
        shutil.rmtree(temp_dir)
    
    print("\n" + "=" * 50)
    print(f"✅ Successfully created {len(fiat_icons) + len(crypto_icons)} currency iconsets!")
    print(f"   - {len(fiat_icons)} fiat currency flags")
    print(f"   - {len(crypto_icons)} crypto currency icons")

if __name__ == "__main__":
    main()

