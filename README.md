
# Babbler
This is a user authenticated social media application that allows you to interact with nearby users (anonymously) in an event-focused chatroom. 

Mingle about an event that you are at! The possibilities are endless.

# Inspiration
I got my inspiration from Yik Yak, as people love to talk anonymously with users nearby. I also got inspiration from Twitch Chat, as people love to interact and message memes during an event. Why not bring these two together into an app? So I did this, and users can joke around with other people about an event.

# What it does
You can create a chatroom, and make an image for a chatroom as well. For example, if you are at a concert, you can take a picture of the stage and have it titled "Drake OVO Stage Jokes" and a description "This is hype". The picture will be the background of the chat (blurred out a bit) to set the mood of the chatroom, and the chat messages last only 10 minutes, to give a more real-time feel.
You can like comments, send pics/memes when something funny or awesome happens!

# How I built it
I used swift in XCode to create this iOS application. Firestore is my database, AVFoundation for camera features, collection views for my home page and chat pages. CoreLocation to get the user's location and check if its in radius of a chatroom, and MKMapKit to get a display of the user's current location. KingFisher API to easily cache URL images.

# Challenges I ran into
CollectionView with a background and inputaccessoryview for the keyboard was very glitchy, the background would nudge whenever the keyboard is dismissed.
 - solved by using a UIView with a collectionview inside
The app would load images from Firestore which costed a lot.
- KingFisher API solved this, easily cache images off the web
Every single chatroom would load and then calculations on checking if it is within range would be done after. If there are MANY chatrooms, the user would load this up everytime, thus using a lot of Firestore reads.
- solved this by querying cities in the chatroom

# Accomplishments that I'm proud of
Committing time in my summer to complete this app, and getting it functionally working. I had an idea and I stuck with it, and created it

# What I learned
I learned a lot of swift knowledge. I was always into iOS and making apps, but finally getting my hands dirty with it, I am certain that iOS dev is a career I want to pursue. If not full time, then on the side I will. I am open for software developer jobs, and I will always create apps on the side. 
