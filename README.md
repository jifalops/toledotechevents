# Toledo Tech Events

An Android, iOS, and soon-to-be web app version of http://toledotechevents.org.

## Why

The project serves as an experiment with new technology and paradigms to accomplish mobile and web apps from a shared code base -- without compromise.

## Mobile, web, and Blocs

While Flutter creates both Android and iOS apps from the same code base, it is not able to output a web app. Instead, AngularDart will be used because it is the same language, Dart, that Flutter uses.

Platform agnostic code can be shared between Flutter and AngularDart using a new architectural pattern called Bloc (Business LOgic Components). Bloc is similar to a presenter in the MVP pattern with a few restrictions:

* `Sink`s for inputs from the View layer.
* `Stream`s for outputs to the View layer.
* Dependencies must be injectable (a function arg) and platform agnostic.
* No platform branching is allowed (if mobile... else if web...).

`Stream`s work both on the web and mobile, so this pattern is focused on encapsulating logic that can be reused in web and mobile.


# Functionality

The app should implement all of the main features of the main site. For extended features the app can just link to that particular part of the site. In particular it should

* List upcoming events
* Show individual event details and allow certain actions such as RSVPing, add to calendar, and showing/launching a map.
* Show a sortable list of venues and offer a details view for each venue.
* Have an *about* section containing the info from the main site.
* Allow users to create events.

# Model View Bloc

This section examines

* What data is at the center of Toledo Tech Events?
* What views can the user see and interact with?
* How does a platform agnostic Bloc mediate between both Flutter and AngularDart views and the underlying data model?

## Model

The heart of the app comes from two pieces of data, an **event list** and a **venue list**. Only events from the current date onwards are in the event list, but the venue list contains cursory data on *all* of the venues. **Event details** and **venue details** must be retrieved individually by their unique IDs.

The data model also contains the main site's **about page**, **add event page**, and some constant and composed **links** to the main website for extended functionality not fulfilled by this project.

## View

There are six primary screens, four top-level screens where the two lists lead to details screens.

```
| Events list
| - Event details
| Venues list
| - Venue detils
| Create event
| About
```

### Primary views

#### Events list

Each event in the list displays the event title, venue title, start time and end time. The user can only interact with the list by refreshing it or selecting an item to bring up the event's details.

#### Event details

The details of an event include a summary of the venue including a map link and a link to the venue's details view. The user can also interact with an RSVP button, add-to-calendar buttons, as well as hyperlinks to the event's related external website and various tags which lead to the main website.

#### Venues list

Each item in the list shows the venue's title, the number of events it's hosted, and when it held its first event. In addition to refreshing and bringing up a venue's details, users can interact with the venues list by sorting it by popularity, recently created, and "hot" which is popularity divided by age.

#### Venue details

Details of a venue include whether it has public WiFi, its homepage, and contact information. Users can interact with this information as hyperlinks or buttons. A venue's details also include upcoming and past events where a user can select an event to view its details.

#### Create event

This screen has several inputs the user can interact with and a button to submit the new event.

#### About page

This screen simply shows the information from the main site's about page. Embedded links are clickable, but no business logic is necessary to handle the links.

### Additional views

#### Navigation bar

For choosing one of the four top-level views.

#### Options menus

From each of the four top-level screens, there is a list of options, each of which is a link external to the app. The venue's list options screen contains an extra option which opens the spam remover screen.

Each of the two details screens contains a unique options menu, but all options are links external to the app.

#### Possible spam venues list screen

This screen shows a list of venues that might need removal. Each list item contains the same information as a venues list item, with the addition of a checkbox input. There is a "delete" floating action button to remove the selected venues, which shows a confirmation dialog. Each list item leads to that venue's details screen.

#### Spam removal confirmation dialog

The dialog shows a title and summary of what is to be deleted, a password input field, and the confirm button.

#### Delete confirmation

A simple dialog for when the users selects the delete menu option.

## Bloc

The view descriptions above roughly outline the data each contains and ways the user can interact with it. This section goes further and lists the platform agnostic input and output data a view's related bloc must have, which omits things like links that change views as opposed to actions that modify the view's state.

Bloc | Outputs to view | Inputs from view
-|-|-
Event list | upcoming events | event selected, refresh
Venue list | sorted venues | venue selected, refresh, sort
Event details |



Finally the model contains a platform agnostic **route manager** and **layout provider** which detects screen size.