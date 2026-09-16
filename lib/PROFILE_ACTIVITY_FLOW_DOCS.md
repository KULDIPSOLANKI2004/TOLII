# Tolii — Activity Creation, Host Management & Profile Flow Architecture

> **Context for Developers & Maintainers**  
> This document explains the end-to-end architecture, wiring, component responsibilities, and UX flow for **Activity Creation**, **Host Management**, **Player Rosters**, **Quick Invites**, and **Profile Dashboard**.

---

## 1. High-Level User Flow

```
[Create Activity Screen]
        │
        ▼ (Saves to ActivitiesController with isHost: true)
[Activity Created Success Screen]
        │
        ├──► (Open Activity) ──────┐
        └──► (Back to Home) ───────┼──► [Profile Tab -> "Upcoming Games"]
                                   │                   │
                                   │                   ▼ (Tap any Game Card)
                                   └─────────► [Activity Detail Screen] (Host View)
                                                       │
                                   ┌───────────────────┴───────────────────┐
                                   ▼                                       ▼
                       [+ Add Button]                           [View All / ⚙ Manage]
                                   │                                       │
                                   ▼                                       ▼
                     [InvitePlayersBottomSheet]                     [PlayersScreen]
                     • Search players                               • Host badge & card
                     • Quick Share (Public, Squads, Link, Share)    • Member roster list
                     • Quick Invites with toggle state              • Sticky Add/Manage actions
```

---

## 2. File Directory & Component Responsibilities

### 1. `lib/models/activity_model.dart`
* **`ActivityModel`**:
  * Represents an event/game.
  * Key fields:
    * `isHost`: `bool` — `true` if the current user created/hosts the game.
    * `venueName` & `venueLocation`: String location details.
    * `venueConfirmed`: `bool` — `true` displays the green venue confirmation checkmark.
    * `players`: `List<PlayerModel>?` — Joined attendees list.
* **`PlayerModel`**:
  * Represents an attendee or prospective invitee.
  * Key fields:
    * `id`: Unique identifier (e.g. `'p_1'`).
    * `name`: Player display name (e.g. `'Meet Patel'`).
    * `role`: `'HOST'` or `'MEMBER'`.
    * `skill`: Skill rating (`'Beginner'`, `'Intermediate'`, `'Advanced'`).
    * `avatarBgColor`: Palette background for user avatar circle.
    * `isHost`: Boolean flag for host badge formatting.
    * `isInvited`: Boolean toggle for invitation state.

---

### 2. `lib/controllers/activities_controller.dart`
* **Singleton State Manager (`ActivitiesController`)**:
  * `activities`: Global feed of all activities in the city.
  * `userActivities`: Activities hosted or joined by the user (shown in Profile -> "Upcoming Games").
  * `quickInvites`: List of suggested contacts for quick invites.
  * **Functions**:
    * `addActivity(ActivityModel activity)`: Adds a newly published activity to index `0` of both `activities` and `userActivities`, marking `isHost: true`.
    * `toggleInvitePlayer(String id)`: Updates player invitation state.
    * `selectFilter()` / `selectDate()`: Filter state handlers.

---

### 3. `lib/views/profile_screen.dart` (Screenshots 3 & 4)
* **Design & Features**:
  * Top navigation with **"My Profile"** and top-right **Settings Gear Button** (opens `EditProfileScreen`).
  * **User Identity Card**: Avatar with initial/photo, name (`Arjun Mehta`), handle (`@arjunm`), and location (`Mumbai, India`).
  * **Stats Row**: `42 PLAYED` | `18 WINS` | `⭐ 4.8 RATING`.
  * **MY SPORTS**: Interactive filter pills (`Cricket`, `Badminton`, `Football`, `Pickleball`).
  * **Active Level**: 4 levels with flame icons (`Warming up`, `Active` [highlighted], `Super Active`, `On fire`) and dynamic progress bar.
  * **Link your Google Fit Card**: Explains workout syncing with bottom sheet flow.
  * **Upcoming Games / Host Activities**:
    * Dynamically listens to `ActivitiesController.userActivities`.
    * Displays cards with sport icon, date/time, venue, participant count, and capacity progress bar.
    * **Wiring**: Tapping any card opens `ActivityDetailScreen(activity: game)` in Host mode.
  * **Recent Activity**: Match history cards (trophy & group icons).
  * **Squads**: Clubs cards (e.g. `Mumbai Cricket Club`).
  * **Log Out**: Red button with confirmation dialog.

---

### 4. `lib/views/edit_profile_screen.dart` (Screenshot 5)
* **Features**:
  * Circular Back button.
  * **Card 1**: Profile avatar placeholder, `"Change Profile Picture"` link, `First Name`, `Last Name`.
  * **Card 2 ("Contact Details")**: `Email`, `Phone`.
  * **Card 3 ("About")**: `Gender` dropdown selector, `Bio` multi-line field.
  * **Bottom Button**: Solid deep blue `Save` button with subtext `"You can edit the details later."`.
  * Returns updated data to `ProfileScreen` upon saving.

---

### 5. `lib/views/activity_detail_screen.dart` (Screenshot 1)
* **Host-Enabled View**:
  * **Header**: Deep blue curved background with back button and share button.
  * **Title & Badge**: Sport title + `6/8 Players` warning pill badge.
  * **Overlapping Venue Card**: `Bhavnagar Pickleball Arena` with `✔ Venue confirmed`.
  * **Stats Row**: 4 cards (`8:00 PM Today`, `6/8 players 2 spots left`, `Beginner Friendly`, `₹150 per person`).
  * **Court Photo**: Pickleball court banner.
  * **Players Section**:
    * `"View all players ->"` link -> opens `PlayersScreen`.
    * Header: `Players (8)` and lock icon `Invite Only`.
    * Vertical roster card showing Meet Patel (`HOST` badge), Rohan Shah, Amit Gohel, Divyesh Solanki.
    * Bottom Action Bar:
      * `+ Add`: opens `InvitePlayersBottomSheet`.
      * `⚙ Manage`: opens `PlayersScreen`.

---

### 6. `lib/views/players_screen.dart` (Screenshot 2 Right)
* **Full Roster Screen**:
  * Back button and centered `"Players"` title.
  * Subheader: `8 Players · 6 Open Spots` + lock icon `Invite Only`.
  * List of player cards:
    * Host card highlighted with blue border and `HOST` badge.
    * Members with `MEMBER` badges and skill levels.
  * Sticky Bottom Action Bar:
    * `"Add Players"` (Outlined blue button) -> opens `InvitePlayersBottomSheet`.
    * `"Manage"` (Solid blue button) -> opens roster options.

---

### 7. `lib/widgets/invite_players_sheet.dart` (Screenshot 2 Left)
* **Invite Sheet**:
  * Drag handle & close button (`X`).
  * Search bar with search icon.
  * **QUICK SHARE OPTIONS** (4 circular buttons):
    1. Switch to Public (globe)
    2. Squads (groups)
    3. Copy Link (chain link with clipboard snackbar)
    4. Share External (system share dialog)
  * **QUICK INVITES**:
    * Pre-populated with players (e.g. `Jayesh Mehta`, `Kunal Pandya`).
    * Tap `"Invite"` -> triggers haptic feedback and toggles to `"Invited"` with checkmark.

---

### 8. `lib/views/community_screen.dart` (Community Dashboard)
* **Design & Features**:
  * Top bar with `'V'` green avatar, `"Hey Vatsal!"`, `"Bhavnagar"`, and notification bell with unread badge.
  * Search bar: `"Search activities, people or places"`.
  * **"Your Communities"**: 6 community groups (`Box Cricket Bhavnagar`, `Weekend Cyclists 🚴`, `Pickleball Players`, `Bhavnagar Football`, `Gaming Hangout`, `Photography Walks`) with unread count badges and timestamps.
  * **"Discover Communities"**: 3 discovery cards (`Sports & Games`, `Cycling Crew`, `Weekend Out`).
  * **Wiring**: Tapping any community navigates to `CommunityChatScreen`.

---

### 9. `lib/views/community_chat_screen.dart` (Activity / Community Chat)
* **Design & Features**:
  * Top bar with deep blue `#063E9E` background, community initials circle, title, subtitle (`"8 members"`), share, and more options.
  * Chat body: Date badge (`"TODAY"`), system notice (`"Vatsal Parmar joined the activity"`), incoming messages (white bubbles), and outgoing user messages (deep blue bubbles).
  * Bottom input bar: `+` attachment button, text input with emoji icon, and solid blue circular send button.
  * Interactive: user can type and send new messages in real-time.

---

## 3. Brand Tokens & Design Rules

* **Primary Color**: `#063E9E` (`AppColors.primary`)
* **Background**: `#F8FAFC` (`Color(0xFFF8FAFC)`)
* **Card Borders**: `#E2E8F0` / `#EFF2F6` (1.0 to 1.2 width)
* **Font Family**: Inter (`AppTypography`)
* **Haptics**: Always call `HapticFeedback.lightImpact()` or `mediumImpact()` on button and sheet triggers.
* **No Pixel Overflows**: All scrollable areas use `BouncingScrollPhysics()` with proper `SafeArea` and `bottomNavigationBar` offsets.

---

## 4. Backend API Integration Guide

When wiring real backend services (e.g. Supabase, Firebase, or Node REST API):
1. Replace `ActivitiesController._initializeData()` with an async `fetchUserActivities()` API call.
2. In `create_activity_screen.dart`, call `POST /activities` and pass the returned `ActivityModel` with the server-generated `id`.
3. In `players_screen.dart`, call `GET /activities/{id}/players` and `POST /activities/{id}/invites`.
4. In `edit_profile_screen.dart`, call `PUT /user/profile` on `Save`.
