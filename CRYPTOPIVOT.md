# Cadenapp - Pivoting to crypto

## Summary

- [Context](#context)
- [The problem we're trying to solve](#the-problem-were-trying-to-solve)
- [Starting principles](#starting-principles)
- [Workflow](#workflow-for-abstracting-crypto-in-a-web-based-p2p-savings-platform)
- [Implementation Steps](#implementation-steps)
- [Benefits](#benefits-of-this-approach)
- [Challenges](#challenges-to-consider)
- [Solving the KYC challenge](#solving-the-kyc-challenge)


## Context
[Cadenapp](https://cadenapp.com/) is a web-based platform that enables users to securely form saving groups among peers, organize their savings collectively, and quickly distribute funds between each other. We built and deployed a web application that allows members to join a saving group, organize a deposit calendar, define a withdrawal schedule, calculate saving goals, receive notifications, and more. We're now on our final sprint before launch which consists of integrating a set of solutions to handle transactions.

## The problem we're trying to solve
- We initially explored using a Banking-as-a-Service (BaaS) provider but found the costs prohibitive. The combination of high service fees, the complexity of their commercial terms, and the resources required in terms of time and technical capacity were too much for our available budget and operational needs.
- We're investigating achieving the same functionality at a much lower cost using a combination of crypto-to-fiat gateways and a custodial wallet.

## Starting principles
- Matching the input and output methods (fiat-in/fiat-out OR crypto-in/crypto-out) is the best approach for user experience and simplicity.
- Keeping the end user experience fiat-focused avoids the need to explain blockchain concepts, wallets, or cryptocurrencies, and broadens the potential user base.
- Using crypto stablecoins to distribute funds internally avoids traditional banking fees and regulatory issues that are suboptimal for frequent micro-transactions in the context of a P2P saving platform.
- Using crypto in the backend outmatches the cost of traditional transactions, but converting to fiat has a cost (both on deposit and withdrawal). We need to find a balance between the two.

## Workflow for abstracting crypto in a web-based P2P savings platform

### 1.	User deposits fiat (using Fiat-to-Crypto gateway):
- Users make a fiat payment through a gateway
- The gateway converts the fiat payment to a stablecoin (e.g. USDC or COPM) and transfers it to a custodial wallet owned by our platform.

### 2.	Hold funds in crypto:
- All users’ stablecoin deposits are collected in a platform-controlled wallet on the Polygon network.
- These funds remain as stablecoin (USDC) until it’s time for withdrawal.

### 3.	Aggregate and sell crypto for fiat:
- When it’s time to pay the designated member, the Rails app triggers a process to:
- Aggregate the stablecoin deposits from the platform wallet.
- Use a crypto-to-fiat service like Circle, Coinbase Commerce, or a decentralized exchange with fiat off-ramps (if available) to convert the stablecoin back to fiat.

### 4.	Send Fiat to the Designated Member:
- The converted fiat funds are transferred to the designated member via a fiat payment gateway (e.g., PayPal, Stripe, or a direct bank transfer API like Plaid or Wise).

## Implementation Steps
### 1. Fiat-to-Crypto gateway integration
- Use APIs from a fiat-to-crypto provider (MoonPay, Ramp, or Transak) to:
    - Accept fiat payments from users within the rails app.
    - Convert these to stablecoins like USDC/COPM on the Polygon network.
    - Deposit the stablecoins into a custodial platform-controlled wallet.
- Providers like Onramper offer white-label solutions where users don’t see any branding from the fiat-to-crypto provider.
- Advanced APIs from providers like Circle let you programmatically initiate fiat-to-crypto conversions without exposing users to third-party interfaces.
- Example flow:
  1. User enters payment amount (e.g., $50).
  2. Fiat-to-crypto gateway handles fiat processing and sends $50 worth of USDC to the platform wallet.

### 2. Platform wallet management
- Maintain a centralized custodial wallet for each group or for the entire app. A custodial wallet is technically a normal crypto wallet but differs in terms of ownership and management : the platform holds private keys and manages funds on behalf of its users. This simplifies the user experience since they don’t need to manage crypto wallets themselves.
- Third-party services like Fireblocks, BitGo, or Venly can be used for custodial wallet management. A custodial wallet can also be built using libraries like web3.js or ethers.js.
- The platform is responsible to track deposits and ensure the balance aligns with user payments. Blockchain APIs like Alchemy, Infura, or Moralis are recommended to track and manage user wallet balances on the Polygon network.

### 3. Stablecoin aggregation and fiat conversion
- At the end of a savings cycle, determine the total stablecoin balance owed to the designated member.
- Use an exchange or fiat off-ramp to convert stablecoins to fiat:
    - Circle: Allows conversion of USDC to fiat and direct deposits into bank accounts.
    - Coinbase Commerce: Allows to manage crypto and offers off-ramp solutions.
    - Centralized Exchanges: Transfer USDC to an exchange (e.g., Binance, Kraken), sell it for fiat, and withdraw fiat.

### 4. Fiat payout to designated member
- After the conversion, use a fiat payment gateway to pay the designated member:
    - Wise: Global bank transfers with low fees.
    - Stripe/PayPal: Instant payouts for users with accounts.
    - Plaid: ACH transfers in the U.S.

## Benefits of this approach
1. Users see only fiat transactions: users deposit fiat and receive fiat, without ever interacting with or seeing crypto.
2. Simplifies UX: no need for users to understand crypto wallets, stablecoins, or blockchain transactions.
3. Reduces volatility risks: using stablecoins like USDC avoids crypto price volatility.
4. Minimizes fees: by pooling transactions, we reduce the number of on-chain operations, lowering fees.

## Challenges to consider
1. Compliance & regulation: fiat-to-crypto gateways and crypto-to-fiat services often require KYC/AML compliance. See more below.
2. Liquidity timing: the fiat conversion process may introduce delays depending on the gateway used. Ensure payouts align with user expectations.
3. Custodial Risks: holding funds in a centralized platform wallet introduces potential security risks. Consider integrating additional security measures like multi-signature wallets.
4. Transaction costs: while crypto reduces some fees, fiat off-ramping and bank payouts may still have associated costs.
5. Reliance on fiat-to-crypto gateways like Ramp or Circle means your system depends on their uptime and fees.

## Solving the KYC challenge
If you implement a custodial wallet and handle fiat-to-crypto conversions, you will likely need to comply with KYC (Know Your Customer) and AML (Anti-Money Laundering) regulations. Fiat-to-Crypto Gateways are legally required to ensure that users are legitimate and not engaging in fraud, money laundering, or other illegal activities. To perform this check, gateways typically require user data like: full name, address, date of birth, government-issued ID (passport, driver’s license, etc.). If our app acts as the intermediary, we must collect and securely transmit this information to the gateway to facilitate transactions.

### How this works in practice
1. User provides data during registration or payment: KYC verification is integrated as part of the onboarding process or at the time of the first fiat-to-crypto transaction.
2. Data sent to fiat-to-crypto gateway: the API or SDK of the gateway is used to send the user’s data securely for verification.
3. Gateway handles compliance: the gateway will validate the user’s identity and flag potential risks.
4. Result: once the user’s identity is verified, the gateway allows transactions to proceed.

### Options for Managing KYC/AML
##### *Option 1:* Delegate to fiat-to-crypto gateway
- Use a third-party gateway (e.g., Ramp, MoonPay, Transak) that includes KYC/AML checks.
- The gateway performs verification directly with users and manages compliance.
- Advantages: reduces liability and operational burden, minimal implementation effort on your end (just an API or widget integration).
- Disadvantages: you must share user data with the gateway, users might experience delays due to verification checks.

##### *Option 2*: Build a proprietary KYC process
- Build and manage a KYC/AML verification system in your app.
- Use third-party tools like SumSub, Jumio, or Onfido to verify user identities.
- Advantages: complete control over user data and branding, can integrate the KYC process directly into app for a seamless experience.
- Disadvantages: Expensive to implement and maintain, directly liable for compliance with local laws.

### Data Privacy Considerations
- Encryption: Ensure that data is encrypted in transit and at rest.
- User consent: Clearly inform users about the data being shared and obtain their consent.
- Data retention: Comply with regulations regarding how long you can store sensitive data.
- Jurisdiction: Be aware of the legal requirements in the countries of operation.
