footer: Steve Freeman - @lotek@genserver.social - github.com/loteks

# Etherchat
Adventures in Irritation Driven Development
h/t to Eddie Lay

---

<br />
<br />

I have over 500 logins stored in 1Password. Only maybe twenty of them are for banks or paid services where a user account is actually necessary.

---

<br />
<br />

In many cases I simply wanted to look at something and then never visited that website again, leaving behind a useless account linked to my email.

---

<br />
<br />

This project questions this design assumption and explores an alternative approach.

---

<br />
<br />

What features do users expect from user accounts?

+ privacy - my chats are my own
+ sharing - sharing is my choice

---

<br />
<br />

How are these features provided by existing services that don't have user accounts?

+ privacy - https://yakgpt.vercel.app uses a uuid to generate an anonymous page
+ sharing - https://etherpad.org uses a crdt data structure to share anonymous pages

---

<br />
<br />

How can we provide these features in Phoenix LiveView?

+ privacy - a random string generator for new pages
+ sharing - Phoenix PubSub

---

<br />
<br />

Controller code to generate a random page

```
def home(conn, _params) do
    chat = MnemonicSlugs.generate_slug(3)
    redirect(conn, to: "/#{chat}")
end
```
---

<br />
<br />

Then put the live page first in the router 

```
live("/:chat", ChatLive)
get("/", PageController, :home)
```

---

<br />
<br />

Code to allow the user to create a new random page

```
push_navigate(socket, to: "/", replace: true)
```
-----

<br />
<br />

Code to allow the user to create a custom page

```
new_page = URI.encode_www_form(custom)
push_navigate(socket, to: "/#{new_page}", replace: true)
```

-----

<br />
<br /> 

This project, powered by ChatGPT, is designed as an AI coding assistant with Phoenix PubSub providing real-time sharing for pair programming.

---

<br />
<br /> 

And having no requirement for user accounts makes using it friction free.

---

<br />
<br /> 

Advantages and disadvantages of Phoenix LiveView

---

<br />
<br /> 

Phoenix PubSub makes real-time sharing relatively simple, 3 lines of code, where similar functionality in Etherpad requires more complex crdts.

---

<br />
<br /> 

The static front page of an Etherpad site helps to make the intended usage clear to the user. The LiveView single page architecture requires more attention to UI design. 

---

<br />
<br /> 

Project site -> https://etherchat.net

Project repo -> github.com/loteks/etherchat

Etherpad demo -> https://indiepad.net

---

<br />
<br />

Many thanks to Brooklin and all my Cohort peeps :)

---