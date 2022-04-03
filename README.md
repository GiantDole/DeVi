# Spectacle
_Enabling borderless and transparent journalism_

A project created at the LionHack blockchain hackathon by Blockchain@Columbia.

## Inspiration

In an ad revenue-driven business such as journalism, it is crucial to report on events before competitors do. Traditionally, media companies rely on a global network of correspondents and dispatch personnel as soon as a newsworthy event occurs. There are significant costs and often long deployment times involved with this approach which we seek to eliminate through our solution. Media companies often have to rely on social media content, which is regularly unverified and biased, while they dispatch their correspondents. Spectacle is a tool that allows journalists to capture and interactively guide video content remotely. 

## What it does

We want to provide journalists with an alternative to existing solutions to acquire good content from news-worthy events with minor delays and lower costs. Spectacle allows journalists to post live-streaming bounties within the vicinity of an event. Spectacle users can view bounties in their vicinity and choose to accept them. Once both parties consent, a smart contract ensures that live streamers can only accept a job if they are in the required location and enforces a pay-per-minute transaction. While live-streaming, the bounty poster can interact with the live streamer via chat and thus guide the content creation. This interaction can be terminated bilaterally, and the footage will be available to the poster for download. 

## How we built it

In Solidity, we developed a bounty factory that is used to create live-stream bounties. A journalist can use the bounty factory to specify and fund a bounty smart contract with longitude, latitude, radius, and bounty per minute. A contractor can accept the bounty by sending along its current longitude and latitude, and the bounty smart contract will verify that the contractor is within the desired area. The journalist can then either accept or reject the contractor. After the contract is mutually accepted, a timestamp ensures compensation according to the length of the live stream. At any point, either the journalist or contractor can terminate the contract, and funds will be distributed to the contractor and Spectacle. Any remaining balance will be returned to the journalist. Now that the contract is complete, both parties can subsequently rate each other, and as all contracts are saved on the blockchain, future users can view the ratings and past jobs.


## Challenges we ran into

Our current implementation requires contractors to have MATIC/ETHER in their wallets to accept a bounty. This may potentially turn away contractors not familiar with crypto from using the platform. To resolve this, our next steps would be to integrate a gas station to help pay initial gas fees for contractors. 

Another challenge we ran into is creating a pay-per-minute payment structure. We are using block.timestamp, but this is an inaccurate measure of time because it is set by the miners. Hence, in the next iteration, a better time measurement needs to be researched and used.

Furthermore, we ran into the problem of how we can ascertain the geolocation of the contractor because geolocations can be forged. Currently, the journalist has to verify this through interactions with the contractor, but we hope to be able to implement better technology such as proof by location to give journalists more confidence in the location of the contractor.

One last challenge, we were not able to address is the termination of the bounty once the funds in the bounty are depleted. In the future, we would like to utilize a decentralized scheduler to automatically terminate a bounty that has no more funds.


## Accomplishments that we're proud of

Although two computer scientists worked on this project, we had to learn and familiarize ourselves with Solidity and the Remix IDE. We are proud that we could build sophisticated smart contracts in such a short amount of time. Additionally, we tested the functionality and considered a variety of attacks (as we come from an IT security background) and could close a bunch of possible misuses of our contracts. 

## What we learned

We learned how to code in Solidity and use the Remix IDE combined with Ganache and Truffle. It was incredibly valuable to engage in the process of acquiring a different perspective on possible vulnerabilities of smart contracts and ensure that only intended functionality can be fulfilled. 
Furthermore, such a small interdisciplinary team of back-end developers, front-end developers, designers, and business analysts allowed for a unique exchange of knowledge and perspectives on blockchain technology and its possible future applications. Although all individuals in our team demonstrated a capacity for efficient communication, we could all benefit from working in such a dynamic environment of continuous exchange across different "teams"/responsibilities.


## What's next for Spectacle

Deployment of an MVP and collaboration with youtube based journalists from international news outlets. The DApp, once deployed and refined, can be used for a host of other use cases, such as remote apartment hunting, scoping out locations before deciding what bar or club to go to on a night out, adult entertainment and more. 
Furthermore, we want to incorporate a Proof of Location protocol such that the location and time of the contractor can be verified. This would allow for non-live video transmission with verified constraints beforehand.

## Additional Links and Resources
Figma: https://www.figma.com/proto/gmseIlqyS4zrnWVAzNPRhd/Project-3?node-id=67%3A834&scaling=scale-down&page-id=0%3A1&starting-point-node-id=67%3A834

YouTube: https://youtu.be/U3XrE_i0dkw
