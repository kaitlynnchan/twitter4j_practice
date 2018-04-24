//Kaitlynn Chan
//2018-04-11
//1-1

import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
import fisica.*;

//fisica
Fisica fisica;
FWorld world;
int gridSize = 40;

//twitter
ConfigurationBuilder cb;
Twitter twitterInstance;
Query queryForTwitter;
String text;

float x = 35, y = 35;
float dx;

FBox character;

PImage[] birdleft;
PImage[] birdright;
PImage[] idle;
PImage[] currentAction;
int costumeNum = 0;

boolean upkey, leftkey, rightkey, downkey;

color blue = #9AE4E8;
color darkblue = #066591;
color white = #FFFFFF;

void setup() {
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(""); 
  cb.setOAuthConsumerSecret("");
  cb.setOAuthAccessToken("");
  cb.setOAuthAccessTokenSecret("");

  twitterInstance = new TwitterFactory(cb.build()).getInstance();

  //twitter bird idle costume
  idle = new PImage[1];
  idle[0] = loadImage("twitter-bird-sprite_01.png");
  idle[0].resize(gridSize, gridSize - 7);

  //twitter bird moving right costume
  birdright = new PImage[3];
  birdright[0] = loadImage("twitter-bird-sprite_02.png");
  birdright[0].resize(gridSize + 2, gridSize - 7);
  birdright[1] = loadImage("twitter-bird-sprite_03.png");
  birdright[1].resize(gridSize + 2, gridSize - 7);
  birdright[2] = loadImage("twitter-bird-sprite_04.png");
  birdright[2].resize(gridSize + 2, gridSize - 7);

  //twitter bird moving left costume
  birdleft = new PImage[3];
  birdleft[0] = loadImage("twitter-bird-sprite_06.png");
  birdleft[0].resize(gridSize + 2, gridSize - 7);
  birdleft[1] = loadImage("twitter-bird-sprite_07.png");
  birdleft[1].resize(gridSize + 2, gridSize - 7);
  birdleft[2] = loadImage("twitter-bird-sprite_08.png");
  birdleft[2].resize(gridSize + 2, gridSize - 7);

  currentAction = idle;

  size (600, 500);
  background(blue);
  Fisica.init(this);
  text = "";
  loadWorld();
}

void fetchAndDrawTweets() {
  ArrayList tweets;
  queryForTwitter = new Query(text);
  try {
    QueryResult result = twitterInstance.search(queryForTwitter);
    tweets = (ArrayList) result.getTweets();
    for (int i = 0; i < 5; i++) {
      Status t = (Status) tweets.get(i);
      String user = t.getUser().getName();
      String profilepicURL = t.getUser().getBiggerProfileImageURL();
      float w = t.getUser().getFollowersCount();
      PImage p = loadImage(profilepicURL);

      String msg = t.getText();
      println(user + ": " + msg);
      println("--------------------------------------------------------------------------------------------------------------------------------");
      
      FBox f = new FBox(p.width, p.height);
      f.setAngularVelocity(random(0, 10));
      f.setPosition(random(200, 400), -50);
      f.attachImage(p);
      world.add(f);
    }
  } 
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

void draw() {
  background(blue);
  world.step();
  world.draw();

  fill(white);
  textSize(30);
  text("#", 50, 50);
  text(text, 70, 50);

  updateCharacter();
  
}

void keyPressed() {
  if (keyCode == UP) upkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == DOWN) downkey = true;
  if (keyCode == RIGHT) rightkey = true;
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) upkey = false;
    if (keyCode == LEFT) leftkey = false;
    if (keyCode == DOWN) downkey = false;
    if (keyCode == RIGHT) rightkey = false;
  } else {
    if (key == BACKSPACE) {
      if (text.length() > 0) {
        text = text.substring(0, text.length() - 1);
      }
    } else if (key == RETURN || key == ENTER) {
      fetchAndDrawTweets();//makeTweetBoxes();
      text = "";
    } else if (key == DELETE) {
      loadWorld();
    } else {
      text += key;
    }
  }
}

