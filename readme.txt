=== Attendance Manager ===
Tags: schedule, attendance, work, employee, online scheduling
Requires at least: 4.1
Tested up to: 5.3
Requires PHP: 5.5
Stable tag: 0.5.8
License: GPLv2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html

Each user can do attendance management by themselves. 


== Description ==



An administrator can do all users’ attendance management.<br>
And each user can do attendance management by themselves.

An attendance schedule is displayed by shortcords.<br>
* Today's staff<br>
* Weekly schedule<br>
* Monthly schedule<br>



== Screenshots ==

1. "Scheduler for Admin" page 
2. "Scheduler for Staff" page 
3. "Today's Staff" page
4. "Weekly schedule" page 
5. "Monthly schedule" page 
6. Plugin option 

== Changelog ==

= 0.5.8 =

* Fixed cURL timeout issue.

= 0.5.7 =

* Fixed a vulnerability issue.

= 0.5.6 =

* 'Screen_icon' on the admin-page has been deleted. And fixed some PHP 'Notice'.

= 0.5.5 =

* Fixed some notices and warnings displayed in "WP_DEBUG" mode has been corrected.

= 0.5.4 =

* Bug fix in calendar navi.

= 0.5.3 =

* Shortcode '[attmgr_today_work id="xx"]' is added.
* The opening hours during midnight will be regarded as "Today".
* Bug fix in calendar.

= 0.5.2 =

* The link of each staff can be given by "Edit User: Website(user_url)".
* An option to use the user avatar on a staff's portrait was added.

= 0.5.1 =

* An "action" URL of the "Settings" form was changed.
* Action hook "parse_request" was changed to "template_redirect".
* These functions were changed, ATTMGR::current_page(), ATTMGR::current_user(), ATTMGR_Form::action(), ATTMGR_Form::access_control().

= 0.5.0 =

* A "Date/Time Format" was added to the plugin option.<br>
Several filter hook were added.<br>
 - 'attmgr_date_format'
 - 'attmgr_month_format'
 - 'attmgr_time_format'
 - 'attmgr_time_format_editor'

* The schedule table name is given from a filter.<br>
 - 'attmgr_schedule_table_name'

* Several filter hook parameter were changed.<br>
 - 'attmgr_shortcode_staff_scheduler'
 - 'attmgr_shortcode_admin_scheduler'
 - 'attmgr_shortcode_daily'
 - 'attmgr_shortcode_weekly'
 - 'attmgr_shortcode_weekly_all'
 - 'attmgr_shortcode_monthly_all'

* Bug fix about submit processing in the scheduler.

* Dutch translation (by Kleijheeg-san) was added.

= 0.4.5 =

* Parameter "guide" was added to short code `[attmgr_daily]`.<br>
usage: `[attmgr_daily guide="week"]`<br>
In this case, the link to each date in a week is shown.<br>
The value of parameter "guide" are "week" or "1week".<br>
In a case of "1week", the link to next week and previous week are not shown.<br>
Parameter "guide" may omit. If "guide" is omitted, the link to each date is not shown.

* Parameter "past" was added to short code `[attmgr_daily]` and `[attmgr_weekly_all]` and `[attmgr_monthly_all]`.<br>
usage(1): `[attmgr_daily guide="week" past="0"]`<br>
usage(2): `[attmgr_weekly_all past="0"]`<br>
In this case, the link to the past is not shown.<br>
Parameter "past" may omit, and default value of "past" is "true".

* "font-size" in the <th> of schedule table was changed.(front.css)

= 0.4.4 =

* Parameter "hide" was added to short code `[attmgr_weekly]`.<br>
usage: `[attmgr_weekly id="xx" hide="1"]`<br>
In this case, it doesn't show anything.<br>
Parameter "hide" may omit, and default value of "hide" is "false".

= 0.4.3 =

* Bug fix.
* Some filters were added.
* Media query is added to "front.css".

= 0.4.2 =

* Some filters were added.

= 0.4.1 =

* Bug fix in "Monthly schedule".

= 0.4.0 =

* When time table is up to the next day like "23:00~08:00", the schedule which continues from the previous day is displayed in "Today's staff" until end time. (In this case, It is until 8:00.)

* Time selection of a scheduler is helped.<br>
When the start time was chosen, standard end time is chosen automatically.<br>
And, the choices of end time are limited to time which is later from the start time.<br>
If start time which is later from the end time is chosen, end time would be reset.

= 0.3.1 =

* Bug fix.

= 0.3.0 =

* Some style classes were added.
* Bug fix.

= 0.2.0 =

* first release.

== Upgrade Notice ==

= 0.5.8 =

Fixed cURL timeout issue.
