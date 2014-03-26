# User

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 1.1   | Create _user_                 | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.2   | Show _user_ dashboard         | -             | Y         | -         | -         | -         | -             | -         | -         | -         | -         |
| 1.3   | Show detail                   | -             | Y         | Y         | Y         | Y         | Y             | -         | -         | -         | Y         |
| 1.4   | Edit _user_ profile           | -             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.5   | Delete _user_                 | -             | -         | -         | -         | -         | -             | -         | -         | -         | -         |
| 1.6   | Add _user_ role               | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.7   | Remove _user_ role            | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.8   | List users                    | -             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |

# User groups

- **[V]**   - visibility of user group
- **[R]**   - relation is get to group owner

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 2.1   | List _user groups_            | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 2.2   | Show detail                   | Y             | Y         | -         | -         | -         | -             | [V]=public| (*1)      | (*2)      | Y         | *1,2 - [V] != owner && if [V] == members => I am member
| 2.3   | View user groups              | Y             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 2.4   | Create _user group_           | Y             | -         | -         | -         | -         | -             | -         | -         | Y         | Y         |
| 2.5   | Edit _user group_             | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 2.6   | Delete _user group_           | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 2.7   | Add user to group             | Y             | Y*        | -         | -         | -         | -             | -         | -         | -         | Y         | user can only add users with existing relation to him, :admin can all
| 2.8   | Remove user from group        | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |

# User relations

- **owner**     - one of relation sides

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 3.1   | List user relations           | Y             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 3.2   | Create confirmed relation     | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 3.3   | Request relation              | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 3.4   | Change my relation status     | Y             | Y (*1)    | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - must be on one relation end
| 3.5   | List relations                | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |

# Variable fields


| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 4.1   | List [own + global]           | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 4.2   | Show detail [own + global]    | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         | Not for :player because sensitible information are present
| 4.3   | View user _variable fields_   | Y             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 4.4   | View user _VF detail_         | -             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 4.5   | Create [global]               | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.6   | Create [own]                  | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 4.7   | Edit [global]                 | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.8   | Edit [own]                    | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.9   | Delete [global]               | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.10  | Delete [own]                  | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |

# Variable field measurements

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 5.1   | Add measurement               | Y             | -         | -         | (*1)      | -         | -             | -         | (2*)      | -         | Y         | *1,2 - only if VF global || owned by user
| 5.2   | Edit measurement              | Y             | Y         | -         | (*1)      | -         | -             | -         | -         | -         | Y         | *1 - only if measured_by == current_user
| 5.3   | Delete measurement            | Y             | Y         | -         | (*1)      | -         | -             | -         | -         | -         | Y         | *1 - only if measured_by == current_user
| 5.4   | Show detail                   | Y             | Y (*1)    | -         | Y         | -         | -             | -         | -         | -         | Y         | *1 - owner = measured_by, (measured_for - discuss??)
| 5.5   | List                          | Y             | -         | -         | -         | -         | -             | -         | Y (*1)    | Y (2*)    | Y         | *1 - can see only own, *2 - can only see own and measurements of his :players
# Organization

**Is postponed to next release.**

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 6.1   | List organizations            | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 6.2   | Show detail                   | -             | Y         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 6.3   | Show public profile           | -             | -         | -         | -         | -         | -             | Y         | Y         | Y         | Y         |
| 6.4   | Create _organization_         | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 6.5   | Edit _organization_           | -             | Y         | -         | -         | -         | -             | -         | -         | -         | -         |
| 6.6   | Delete _organization_         | -             | Y         | -         | -         | -         | -             | -         | -         | -         | -         |