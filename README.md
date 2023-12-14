Welcome to our app: “Chordable”

This is an IOS mobile application written in Swift as part of our project for course 67-443, affiliated with Carnegie Mellon University

Contributors: Minjoo Kim, Ariel Kwak, Owen Gometz
Contact: owengometz@gmail.com

*NOTE: If you are not a grader, please skip to “Additional Notes” at the bottom

______________________________

Overview:

Chordable is an app for beginning guitar players who want to learn to play. Users can browse our selection of 24 chords to learn, and 188 songs to play. All chords are initially incomplete, and similarly, all songs are initially locked. In order to complete a chord, users can navigate to our Chords tab, click on a desired chord, and make use of several diagrams and sample audio in order to learn that chord. When users feel they are ready, they can utilize our “Try It” feature to record themselves playing a strum of that chord, to which the app will respond with success or try again feedback. Powered by our chord_recognition machine learning model, if it was a success, that chord has been completed. Songs are categorized into several genres, from which users can browse through. In order to unlock a song within any genre, users must complete all the chords present in that song. Users are made aware of which chords are required of any given song. Once users unlock a song, they gain access to the play-along feature for that song. The specific song plays in the background as an animation is displayed, showing chord transitions at the correct timing so users can effectively play-along with the song. Users can track their overall progress with the app by visiting the home page, which displays several metrics for growth. Users can always re-learn chords and restart songs.

______________________________

Users:

Understand that our app is for beginner, motivated guitarists. Meeting the needs of all experience levels would be out-of-scope for this project, and focusing on one demographic has led to a robust and simple app that doesn’t over-extend itself. As such, our app is catered toward users with little-to-no experience with the guitar, and is meant to serve as a tool for them until they become intermediate players. Furthermore, it needs to be understood that learning an instrument is notoriously hard to stick with. We all know people who have tried and failed, probably multiple times. Our app was designed with the assumption that those downloading our app are ready to begin an extended process, because that's what it takes to learn an instrument regardless of the appeal of an app. It is imperative to fully acknowledge this frame of mind for our users before evaluating the viability of a potential business model surrounding this app.

______________________________

Data:

Given the correct understanding of our target objective and intended user, we have thoughtfully equipped our app with data sources to cater to our users’ needs. Chordable offers support for 24 beginner-friendly chords: the basic major and minor chords. 2 for each of the 12 notes on the musical scale. This choice was made to not overwhelm users with complicated chord shapes and musical semantics that would deter a beginner. There is a seamless progression of easy, medium to hard chords comprising our selection. Furthermore, Chordable supports 188 classic songs from the late 20th century that are recognizable, with mostly simple progressions. Users will find that perfecting chord transition timing is made much easier when there is a simple and slow progression and when they recognize the tune. The data on these songs have been gathered from a public github repository, credits to tmc323: https://github.com/tmc323/Chord-Annotations/tree/master

Indeed, once users complete all 24 chords, and subsequently unlock all 188 songs there is no more upward mobility aside from perfecting the songs. However, once users reach this level they inherently become out-of-scope for our App, and we will have successfully brought them to intermediate status. Further work on this app can be done to increase the chord and song selection to appeal to more advanced players.

______________________________

Technical Implementation:

In our pursuit of delivering a seamless and highly optimized user experience on Apple devices, our team has chosen to use Core Data, Apple's own robust and comprehensive framework. This natively stores and manages our application's data, ensuring that our solution is not only well-integrated within the Apple ecosystem but also benefits from the efficiency and advanced features that Core Data offers. This decision allows for faster data access speeds and the ability to function seamlessly without the need for a continuous Wi-Fi connection. Further, since our app does not store a very large amount of data, employing Core Data does not impose significant storage burdens on our users' devices, thereby maintaining a lightweight and efficient user experience. Our data requirements also fit well with the Object-Relational Mapping framework, since all of our data is easily represented with entity definitions and relationships between them.

In regards to the machine learning model that powers our app’s chord recognition capabilities, this was a model that was built from scratch. Albeit with the use of the handy scikit-learn Python library, all of the training data was recorded personally by the developers. The model is trained on 75 raw audio files for each of the 24 chords, totalling 1800 files in total. The recordings were gathered using various guitars in different settings to justify a generalizable model. Further, to artificially increase the sample size, 5 iterations of augmentations were applied to add white noise, slightly increase & lower pitch, and speed up & down the files. This totals to 10,800 pieces of training data. All this was done in efforts to produce a model that will make accurate predictions in the variety of settings that users may find themselves in. In terms of deployment, this ML model was embedded within a Flask app, which was uploaded to a pythonAnywhere supported environment, from which we could make POST requests from our IOS app.

Finally, our team has integrated with the Spotify API to further benefit our users. When browsing through songs, the album covers are acquired from the Spotify endpoint so that users have a higher likelihood of recognizing a song, and in turn becoming more motivated to unlock it and play along. Additionally, when users unlock songs, they can view an animation which shows when to transition between chords while the song is simultaneously playing in the background. This is made possible through our use of the Spotify API.

______________________________

Miscellaneous Design Decisions:

Within the Home tab, we made several design choices to enhance the experience for our users. We wanted to display three metrics: day streak, chords completed, and songs unlocked. In our view, these are the most apparent indicators of progress for our users. We wanted this to be a page that users could look at, and feel motivated to continue their progress.

In the Chords tab, specifically the chord-learning view for a specific chord, we have decided to disable all buttons while the user is recording themselves. This makes for a controlled environment for them to record themselves, and protects against accidental clicks.

In the songs play-along feature, there is a play-along toggle, and a restart button. The restart button can only be clicked when the song is at a paused state. Additionally, the play-along toggle can only be toggled when the song is at its starting position. These were choices that were made to simplify the play-along experience.

Furthermore, you will notice that the Chord names displayed in the Chords tab include the chord name, and the quality (major or minor). However, the chord names displayed in the play-along feature are shown a bit differently. Minor chords have a trailing lower-case “m,” and all other chords are understood to be major. This was done for several reasons. First, including the full word “major” or “minor” would make for a very unattractive and visually displeasing animation, especially given our choice to show the chords in small circles. Also, this will get our users more used to different chord name displays, commonly found in the music industry and online resources.

______________________________

Testing:

From our testing suite, you will see two top-level folders: 443-Chordable.app, and SpotifyAPI. Given that the SpotifyAPI has been thoroughly tested publicly, our team did not test this component. You will find that the 443-Chordable.app has under 25% coverage. I am unspecific here due to the fact that this metric is subject to seemingly random change. Without modifying any tests, different runs of our testing suite will result in both ~23.6% coverage of our app, and also ~11.1% coverage. Please run our testing suite at least 3 times back to back to get the most accurate results. The 23.6% coverage run is the accurate report.

First and foremost, the largest contributing factor in this low coverage is due to the View files. Since we were not required to test the View files, the coverage on these files is generally low (some tests cover components of the View files, apparently). Furthermore, given that our app largely uses audio tracking which resulted in variable asynchronous wait times, testing posed a challenge for our group. For instance, a file like SongsForGenreViewController is incredibly difficult to test, since it requires the Spotify extension as part of its setup and functionality. As such, all of the functions within this controller rely on this extension. Building workarounds and/or mockSpotify classes to test these functionalities made little sense, given that we know the Spotify functions we are using have been thoroughly tested already. Therefore, this file is left untested. To add, you will see that some files have less than 100% coverage. For example, within the ChordDetailViewController, functions like playChords, which rely on connecting to audio which cause a whole plethora of inconsistencies as it relates to timing, are left untested. Regardless, we ran the calculations on total coverage and even in spite of these justified decisions, our total coverage on files that are expected to be tested is above 90%.

Please be aware that due to variable wait times for test functions that rely on audio or recording timers, there is a possibility that certain tests may fail. Similar to the aforementioned indiscriminate reporting of test coverage, we have noticed that separate runs of the same test suite will result in different outcomes for certain functions. We believe that we have made modifications that make it very unlikely that this will happen, but it may.

As a last note, you may find that running the tests will produce some error messages in the terminal, specifically related to CoreData. We took a deep-dive into this issue, and determined that our setup and teardown methods within each test class work as expected, so we made the choice to prioritize maximizing testing rather than spend unnecessary time on an error that was not outwardly blocking us from realizing a respectable coverage.

______________________________

Additional Notes:

This section is meant to inform users on potential mishaps regarding installation, onboarding, and other scenarios one might find themselves in when interacting with our app.

Connecting to Spotify:
Upon opening the app, you will see the Welcome screen, where you are supposed to enter your name and continue. After this, you will see a page where you can connect to Spotify. You will see a white button at the bottom that is supposed to say “Connect to Spotify.” On the iPhone, this text may not show, even though the button will. On the simulator app on a MacOS device, this has never been an issue, but for some reason there is a bizarre effect that our app has on the iPhone itself that causes this. Click the blank white button and proceed to input your Spotify credentials. 
Please note that you must have a paid account to use our app.
This should not happen, but there is a chance that after you follow the steps and navigate back to the app, nothing happens and you stare at a blank screen. Or maybe you will see a loading screen for a long time. We suspect that this has to do with the way our team has handled returning downloaders, and that it only affects us developers who constantly reinstall the app for testing purposes. Therefore, we don’t expect this to be an issue. We have a method of getting around this, so if this arises please get in contact with the development team. But as long as you only download the app once, you should not experience this issue.
After you get past these steps, please navigate to the songs tab, click on a genre, and confirm that you are able to see the images of album covers alongside song titles. If you do, then you are connected to Spotify properly, if you cannot, there is an issue.

~

First-time use: 
When navigating back to the app after the Spotify onboarding, and assuming you are properly directed to the Home tab, there is a chance that the app freezes when you try to click on another tab. This is very rare, but it has happened a few times in the stages of development for unknown reasons. However, you can get around this issue by exiting the app and going back into it. If this fails, try deleting the app, re-installing, and going through the steps again. We can guarantee that these steps will solve this issue. If not, reach out to the development team. Again, this has only ever been an issue on the iphone, not the computer simulator.

~

Chord recognition response time:
Especially on the first few uses, the chord recognition feature may take several seconds. In our experience, the wait time never exceeds 10 seconds. This sounds like a lot, but this has only ever happened once in the earlier stages of development. More recently, the feedback takes 1-3 seconds for the first few uses, and after that they are almost instantaneous.

~

Model inaccuracy:
As with any machine learning model, random error is an inevitable factor. Especially within our timeframe and scope of the project, the model was only able to be trained on 10,800 audio files. This may sound like a lot, but more sophisticated ML models are trained on millions of pieces of data. As such, there isn’t enough data for the model to be completely certain on the distinction between the chords. Every prediction is a best guess, so there will be times where a chord was played properly, but the model predicts the incorrect chord. Even though our tests indicate an accuracy rate of above 90%, we suggest trying out the recognition at least 3 times for a particular chord for best results.

~

Stubborn chords:
In the same vein as the previous note, there are some chords that are particularly stubborn. By this, we mean that there are chords that our model consistently reports inaccurately, ultimately making them consistently difficult to complete. Over the course of this project, the set of stubborn chords has surprisingly evolved, perhaps due to the recording setting, device type, or other factors. At the moment, and identified by thorough testing, the chords you can expect that E major, E minor, and G major are particularly stubborn. Perhaps F major/minor, and F# major/minor as well. However, this may not be the case for all guitar users in all settings. You can do the following to tackle these chords:

Strum the guitar close to the microphone

Go to a quiet setting with little to no background noise

Try different strumming speeds, slow and fast

Try strumming multiple times within the 5 second duration

Try emphasizing (play louder) the specific strings that define that chords quality (major or minor). For clarity, the model often thinks an A major is an A minor, or an E major is an E minor, and vice versa. What you can do, in the case of E major/minor, is play the G string (the string that separates the two chords) more loudly/clearly than the other strings, so the model has more pronounced data to differentiate between the two.

If you are advanced, you can also try playing a different variation of the chord than is listed on the app. For instance, try playing an A bar chord on the 5th fret instead of the open A.

Please be patient. Keep trying the chords and they will eventually complete

~

Unlocking songs:
We have implemented certain methods of letting users know where they stand in terms of song progress in the Songs tab. For instance, at the top of the Songs tab we display the number of songs unlocked. Also, underneath each genre we display the number of songs that the user has unlocked in that genre. Finally, If a user clicks on the title of a locked song, they can see the chords required of that song. Completed chords are highlighted purple, and incomplete chords aren’t. If a user navigates to a chord from the Chords tab itself, and completes a chord, all of these metrics will immediately update. The number of songs unlocked will update, and the coloration will go to purple once they navigate to the songs tab. However, if a user clicks on one of these chords directly from the Songs tab, then they complete it, and then they click the back button, the user has to click around a bit to see the change reflected. Likewise, if a user has completed all the chords for a song, and they click the back button, they would need to click the unlocked tab to actually see the change in song status. This isn’t inherently a flaw, because apps like DuoLingo also often don’t show immediate state changes, but we thought it would be best to state this here so as to not create confusion.

~

Play-along feature:
Please have spotify open on your device in the background to utilize this feature. And please do not interact with spotify while our app is running. Also, you can use headphones while utilizing this feature, but be sure to not accidentally pause the song by taking an airpod out, because the spotify song will pause, but not the animation, so it will be out of sync and you will have to restart.

~

Some songs are better than others:
Within the play-along feature, given that the Spotify soundtrack may need a second or two to boot up, some songs may not line up perfectly with the chord-transition animation. For the best experience, we suggest starting the song for a few seconds, pausing it, and restarting. We have experienced that this will allow for a faster start-up time for the song, and it will match-up better. Even with this adjustment, there are some songs that don’t quite match up perfectly. All songs are certainly playable, and advanced guitarists can fill in the gaps, but some songs are more smooth than others. Songs like “Genie in a Bottle” by Christina Agulara have quick transitions at the beginning that don't allow time for Spotify's loading, causing a choppy flow.
Here is a list of songs that we can confirm are very user-friendly and fun to play along with:

Dancing Queen: Pop

I Believe: Pop

I Want it That Way: Pop

Beat It: Rock

Have You Ever Seen The Rain: Rock

I Believe I Can Fly: R&B / Soul

Take Me Home Country Roads: Folk & Country

Wonderwall: Alternative

Yellow: Alternative

