# Fake Gold Bar Detector

This project automates the process of identifying the fake gold bar among a set of nine bars using a balance scale on the website [SDET Challenge](https://sdetchallenge.fetch.com/). The script utilizes the Selenium WebDriver in Ruby to simulate user interactions with the website, determining the fake bar in a minimum number of weighings.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Algorithm Explanation](#algorithm-explanation)

## Prerequisites

Before running the script, ensure you have the following software installed:

- [Ruby 3.3.4](https://www.ruby-lang.org/en/downloads/)
- [Google Chrome](https://www.google.com/chrome/)
- [ChromeDriver](https://sites.google.com/chromium.org/driver/)
- [Bundler](https://bundler.io/)

## Installation

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/rrdabreo/fake-gold-bar.git
    cd fake-gold-bar
    ```

2. **Install Dependencies**:
    The project uses Selenium WebDriver, so you'll need to install the necessary Ruby gems. Run the following command:
    ```bash
    bundle install
    ```

3. **Set Up ChromeDriver**:
    Ensure that ChromeDriver is installed and its path is added to your system's environment variables. The ChromeDriver version should match your installed Chrome browser version.

## Usage

1. **Run the Script**:
    To execute the script and identify the fake gold bar, run:
    ```bash
    ruby find_fake_gold_bar.rb
    ```

2. **Watch the Automation**:
    The script will open a Chrome browser window, navigate to the SDET Challenge website, and begin the process of weighing the bars to identify the fake one.

3. **Results**:
    The script will output the number of weighings performed and the final result, displaying whether the correct bar was identified.

## Algorithm Explanation

The script employs a divide-and-conquer algorithm to minimize the number of weighings needed to find the fake gold bar. Here's a high-level overview:

1. **Initial Weighing**:
    - The first weighing compares two groups of three bars each (`[0,1,2]` vs `[3,4,5]`).
    - Based on the result, the script identifies which group (if any) contains the lighter (fake) bar.

2. **Second Weighing**:
    - The script then compares two bars within the identified group.
    - If these bars balance, the remaining bar is identified as the fake bar. Otherwise, the lighter bar in the comparison is the fake one.

3. **Final Click**:
    - Once identified, the script clicks on the button corresponding to the fake bar and captures the alert message confirming the result.
