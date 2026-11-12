import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Language toggle: always names the OTHER language, in that language.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get switchLanguage;

  /// No description provided for @navWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get navWork;

  /// No description provided for @navPlayground.
  ///
  /// In en, this message translates to:
  /// **'Playground'**
  String get navPlayground;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @startProject.
  ///
  /// In en, this message translates to:
  /// **'Start a project'**
  String get startProject;

  /// No description provided for @hireMe.
  ///
  /// In en, this message translates to:
  /// **'Hire me'**
  String get hireMe;

  /// No description provided for @openMenu.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get openMenu;

  /// No description provided for @inspectOn.
  ///
  /// In en, this message translates to:
  /// **'Inspect: on'**
  String get inspectOn;

  /// No description provided for @inspectOff.
  ///
  /// In en, this message translates to:
  /// **'Inspect: off'**
  String get inspectOff;

  /// No description provided for @inspectTooltipOn.
  ///
  /// In en, this message translates to:
  /// **'Inspector mode on: hide layout and code'**
  String get inspectTooltipOn;

  /// No description provided for @inspectTooltipOff.
  ///
  /// In en, this message translates to:
  /// **'Inspector mode: show the layout and code behind the site'**
  String get inspectTooltipOff;

  /// No description provided for @inspect.
  ///
  /// In en, this message translates to:
  /// **'Inspect'**
  String get inspect;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @themeToLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light theme'**
  String get themeToLight;

  /// No description provided for @themeToDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get themeToDark;

  /// No description provided for @inspectorBanner.
  ///
  /// In en, this message translates to:
  /// **'Inspector mode is on. Hover a section for its widget and size; click one to open the inspector. Demos show the real source.'**
  String get inspectorBanner;

  /// No description provided for @howSiteBuilt.
  ///
  /// In en, this message translates to:
  /// **'How this site is built'**
  String get howSiteBuilt;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @seeTheWork.
  ///
  /// In en, this message translates to:
  /// **'See the work'**
  String get seeTheWork;

  /// No description provided for @sectionSelectedWork.
  ///
  /// In en, this message translates to:
  /// **'Selected work'**
  String get sectionSelectedWork;

  /// No description provided for @allWork.
  ///
  /// In en, this message translates to:
  /// **'All work'**
  String get allWork;

  /// No description provided for @sectionTryOne.
  ///
  /// In en, this message translates to:
  /// **'Try one'**
  String get sectionTryOne;

  /// No description provided for @sectionWhatIDo.
  ///
  /// In en, this message translates to:
  /// **'What I do'**
  String get sectionWhatIDo;

  /// No description provided for @waysToWork.
  ///
  /// In en, this message translates to:
  /// **'Ways to work together'**
  String get waysToWork;

  /// No description provided for @sectionClients.
  ///
  /// In en, this message translates to:
  /// **'What clients say'**
  String get sectionClients;

  /// No description provided for @allReviewsFiverr.
  ///
  /// In en, this message translates to:
  /// **'All reviews on Fiverr'**
  String get allReviewsFiverr;

  /// No description provided for @sectionHowIWork.
  ///
  /// In en, this message translates to:
  /// **'How I work'**
  String get sectionHowIWork;

  /// No description provided for @sectionTellMe.
  ///
  /// In en, this message translates to:
  /// **'Tell me what you\'re building'**
  String get sectionTellMe;

  /// No description provided for @copyEmail.
  ///
  /// In en, this message translates to:
  /// **'Copy email address'**
  String get copyEmail;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email address copied'**
  String get emailCopied;

  /// No description provided for @reviewLabel.
  ///
  /// In en, this message translates to:
  /// **'{source} review'**
  String reviewLabel(String source);

  /// No description provided for @colNo.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get colNo;

  /// No description provided for @colProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get colProject;

  /// No description provided for @colType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get colType;

  /// No description provided for @colYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get colYear;

  /// No description provided for @stack.
  ///
  /// In en, this message translates to:
  /// **'Stack'**
  String get stack;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @openCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'Open case study'**
  String get openCaseStudy;

  /// No description provided for @openCaseStudyOf.
  ///
  /// In en, this message translates to:
  /// **'Open the {title} case study'**
  String openCaseStudyOf(String title);

  /// No description provided for @showOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Show {title} on the phone'**
  String showOnPhone(String title);

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @videoPaused.
  ///
  /// In en, this message translates to:
  /// **'Video · paused'**
  String get videoPaused;

  /// No description provided for @loop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get loop;

  /// No description provided for @playLoop.
  ///
  /// In en, this message translates to:
  /// **'Play the loop'**
  String get playLoop;

  /// No description provided for @noFootage.
  ///
  /// In en, this message translates to:
  /// **'No footage yet'**
  String get noFootage;

  /// No description provided for @figCaption.
  ///
  /// In en, this message translates to:
  /// **'Fig. {n} · {caption}'**
  String figCaption(int n, String caption);

  /// No description provided for @screenCaption.
  ///
  /// In en, this message translates to:
  /// **'Screen {n}: {caption}'**
  String screenCaption(int n, String caption);

  /// No description provided for @footageOf.
  ///
  /// In en, this message translates to:
  /// **'{title} footage'**
  String footageOf(String title);

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @awaitingFootage.
  ///
  /// In en, this message translates to:
  /// **'Awaiting footage'**
  String get awaitingFootage;

  /// No description provided for @inspectThisPage.
  ///
  /// In en, this message translates to:
  /// **'Inspect this page'**
  String get inspectThisPage;

  /// No description provided for @stopInspecting.
  ///
  /// In en, this message translates to:
  /// **'Stop inspecting'**
  String get stopInspecting;

  /// No description provided for @liveSpecimenCaption.
  ///
  /// In en, this message translates to:
  /// **'Fig. 1 · A live FilledButton. Drag to change its padding.'**
  String get liveSpecimenCaption;

  /// No description provided for @paddingValue.
  ///
  /// In en, this message translates to:
  /// **'Padding {n}'**
  String paddingValue(int n);

  /// No description provided for @footer.
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get footer;

  /// No description provided for @footerColophon.
  ///
  /// In en, this message translates to:
  /// **'© {year} {name} · Built in Flutter, every pixel a widget.'**
  String footerColophon(String year, String name);

  /// No description provided for @controls.
  ///
  /// In en, this message translates to:
  /// **'CONTROLS'**
  String get controls;

  /// No description provided for @readouts.
  ///
  /// In en, this message translates to:
  /// **'READOUTS'**
  String get readouts;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'− hide'**
  String get hide;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'+ show'**
  String get show;

  /// No description provided for @ocWidth.
  ///
  /// In en, this message translates to:
  /// **'width'**
  String get ocWidth;

  /// No description provided for @ocSizeClass.
  ///
  /// In en, this message translates to:
  /// **'size class'**
  String get ocSizeClass;

  /// No description provided for @ocSelected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get ocSelected;

  /// No description provided for @ocLayout.
  ///
  /// In en, this message translates to:
  /// **'layout'**
  String get ocLayout;

  /// No description provided for @ocNone.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get ocNone;

  /// No description provided for @ocListDetail.
  ///
  /// In en, this message translates to:
  /// **'list + detail'**
  String get ocListDetail;

  /// No description provided for @ocOnePane.
  ///
  /// In en, this message translates to:
  /// **'one pane'**
  String get ocOnePane;

  /// No description provided for @ocPhone.
  ///
  /// In en, this message translates to:
  /// **'phone'**
  String get ocPhone;

  /// No description provided for @ocTablet.
  ///
  /// In en, this message translates to:
  /// **'tablet'**
  String get ocTablet;

  /// No description provided for @ocDesktop.
  ///
  /// In en, this message translates to:
  /// **'desktop'**
  String get ocDesktop;

  /// No description provided for @ocOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ocOrders;

  /// No description provided for @ocShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get ocShipping;

  /// No description provided for @ocSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ocSettings;

  /// No description provided for @ocOakDesk.
  ///
  /// In en, this message translates to:
  /// **'Oak desk'**
  String get ocOakDesk;

  /// No description provided for @ocWoolRug.
  ///
  /// In en, this message translates to:
  /// **'Wool rug'**
  String get ocWoolRug;

  /// No description provided for @ocDeskLamp.
  ///
  /// In en, this message translates to:
  /// **'Desk lamp'**
  String get ocDeskLamp;

  /// No description provided for @ocBookshelf.
  ///
  /// In en, this message translates to:
  /// **'Bookshelf'**
  String get ocBookshelf;

  /// No description provided for @ocSideTable.
  ///
  /// In en, this message translates to:
  /// **'Side table'**
  String get ocSideTable;

  /// No description provided for @ocFloorLamp.
  ///
  /// In en, this message translates to:
  /// **'Floor lamp'**
  String get ocFloorLamp;

  /// No description provided for @ocShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get ocShipped;

  /// No description provided for @ocPacking.
  ///
  /// In en, this message translates to:
  /// **'Packing'**
  String get ocPacking;

  /// No description provided for @ocPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get ocPaid;

  /// No description provided for @ocCarrierA.
  ///
  /// In en, this message translates to:
  /// **'Carrier A · 2 days'**
  String get ocCarrierA;

  /// No description provided for @ocCarrierB.
  ///
  /// In en, this message translates to:
  /// **'Carrier B · 5 days'**
  String get ocCarrierB;

  /// No description provided for @ocPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup · free'**
  String get ocPickup;

  /// No description provided for @ocNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications · on'**
  String get ocNotifications;

  /// No description provided for @ocCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency · USD'**
  String get ocCurrency;

  /// No description provided for @ocLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language · English'**
  String get ocLanguage;

  /// No description provided for @ocSelectOrder.
  ///
  /// In en, this message translates to:
  /// **'Select an order'**
  String get ocSelectOrder;

  /// No description provided for @ocDetailBlurb.
  ///
  /// In en, this message translates to:
  /// **'The same detail widget is a full page on a phone and a pane on a desktop. Only the layout around it changes.'**
  String get ocDetailBlurb;

  /// No description provided for @notFoundLead.
  ///
  /// In en, this message translates to:
  /// **'There is no sheet at this address.'**
  String get notFoundLead;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get backHome;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @basedIn.
  ///
  /// In en, this message translates to:
  /// **'Based in'**
  String get basedIn;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @pgLead.
  ///
  /// In en, this message translates to:
  /// **'Experiments, each proving one thing. Turn the knobs, break things and watch the app cope.'**
  String get pgLead;

  /// No description provided for @pgColSpecimen.
  ///
  /// In en, this message translates to:
  /// **'Specimen'**
  String get pgColSpecimen;

  /// No description provided for @pgColProves.
  ///
  /// In en, this message translates to:
  /// **'What it proves'**
  String get pgColProves;

  /// No description provided for @pgColTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get pgColTags;

  /// No description provided for @spTryThis.
  ///
  /// In en, this message translates to:
  /// **'TRY THIS'**
  String get spTryThis;

  /// No description provided for @spWhyHard.
  ///
  /// In en, this message translates to:
  /// **'WHY IT\'S HARD'**
  String get spWhyHard;

  /// No description provided for @abToolbox.
  ///
  /// In en, this message translates to:
  /// **'Toolbox'**
  String get abToolbox;

  /// No description provided for @abBuiltLead.
  ///
  /// In en, this message translates to:
  /// **'A Flutter web app, top to bottom. Switch on Inspect to see the layout of any page.'**
  String get abBuiltLead;

  /// No description provided for @abImportNote.
  ///
  /// In en, this message translates to:
  /// **'Read top to bottom: what you see, what it is built from, what it stands on.'**
  String get abImportNote;

  /// No description provided for @skillLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get skillLanguages;

  /// No description provided for @skillFrameworks.
  ///
  /// In en, this message translates to:
  /// **'Frameworks'**
  String get skillFrameworks;

  /// No description provided for @skillBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend & APIs'**
  String get skillBackend;

  /// No description provided for @skillState.
  ///
  /// In en, this message translates to:
  /// **'State management'**
  String get skillState;

  /// No description provided for @skillNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get skillNavigation;

  /// No description provided for @ctLead.
  ///
  /// In en, this message translates to:
  /// **'Tell me what you\'re building and where you\'re stuck. I\'ll reply with how I\'d approach it and what it would take.'**
  String get ctLead;

  /// No description provided for @ctQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get ctQuestions;

  /// No description provided for @ctBestFor.
  ///
  /// In en, this message translates to:
  /// **'Best for: {what}'**
  String ctBestFor(String what);

  /// No description provided for @ctFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String ctFrom(String price);

  /// No description provided for @ctWriteDirectly.
  ///
  /// In en, this message translates to:
  /// **'Or write directly'**
  String get ctWriteDirectly;

  /// No description provided for @ctEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get ctEmail;

  /// No description provided for @ctNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get ctNameRequired;

  /// No description provided for @ctEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get ctEmailRequired;

  /// No description provided for @ctEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get ctEmailInvalid;

  /// No description provided for @ctProjectKind.
  ///
  /// In en, this message translates to:
  /// **'What kind of project?'**
  String get ctProjectKind;

  /// No description provided for @ctBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget (optional)'**
  String get ctBudget;

  /// No description provided for @ctBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Select a range'**
  String get ctBudgetHint;

  /// No description provided for @ctMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get ctMessage;

  /// No description provided for @ctMessageHelper.
  ///
  /// In en, this message translates to:
  /// **'Ctrl + Enter to send'**
  String get ctMessageHelper;

  /// No description provided for @ctMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please tell me a little about the project'**
  String get ctMessageRequired;

  /// No description provided for @ctSend.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get ctSend;

  /// No description provided for @ctSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get ctSending;

  /// No description provided for @ctOpeningEmail.
  ///
  /// In en, this message translates to:
  /// **'Opening your email…'**
  String get ctOpeningEmail;

  /// No description provided for @ctSent.
  ///
  /// In en, this message translates to:
  /// **'Thanks, your message was sent. I\'ll reply to {email}.'**
  String ctSent(String email);

  /// No description provided for @ctSentMailto.
  ///
  /// In en, this message translates to:
  /// **'If no email app opened, email me at {email}'**
  String ctSentMailto(String email);

  /// No description provided for @ctFailedForm.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send your message: {error} Please email me at {email} instead.'**
  String ctFailedForm(String error, String email);

  /// No description provided for @ctFailedMailto.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your email app. Please write to {email} directly.'**
  String ctFailedMailto(String email);

  /// No description provided for @ctServiceStatus.
  ///
  /// In en, this message translates to:
  /// **'The form service answered {code}.'**
  String ctServiceStatus(int code);

  /// No description provided for @ctServiceUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the form service.'**
  String get ctServiceUnreachable;

  /// No description provided for @dsRowsBuilt.
  ///
  /// In en, this message translates to:
  /// **'rows built'**
  String get dsRowsBuilt;

  /// No description provided for @dsMatching.
  ///
  /// In en, this message translates to:
  /// **'matching'**
  String get dsMatching;

  /// No description provided for @dsMatchingValue.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total}'**
  String dsMatchingValue(String shown, String total);

  /// No description provided for @dsFrameTime.
  ///
  /// In en, this message translates to:
  /// **'frame time'**
  String get dsFrameTime;

  /// No description provided for @dsList.
  ///
  /// In en, this message translates to:
  /// **'list'**
  String get dsList;

  /// No description provided for @dsNaiveCapped.
  ///
  /// In en, this message translates to:
  /// **'naive, first 10,000'**
  String get dsNaiveCapped;

  /// No description provided for @dsVirtualized.
  ///
  /// In en, this message translates to:
  /// **'virtualized'**
  String get dsVirtualized;

  /// No description provided for @dsNaive.
  ///
  /// In en, this message translates to:
  /// **'naive'**
  String get dsNaive;

  /// No description provided for @dsRows.
  ///
  /// In en, this message translates to:
  /// **'rows'**
  String get dsRows;

  /// No description provided for @dsSort.
  ///
  /// In en, this message translates to:
  /// **'sort'**
  String get dsSort;

  /// No description provided for @dsAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get dsAmount;

  /// No description provided for @dsStatus.
  ///
  /// In en, this message translates to:
  /// **'status'**
  String get dsStatus;

  /// No description provided for @dsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dsAll;

  /// No description provided for @dsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get dsOpen;

  /// No description provided for @dsLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get dsLate;

  /// No description provided for @dsSearch.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get dsSearch;

  /// No description provided for @dsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Name or ID'**
  String get dsSearchHint;

  /// No description provided for @dsNoRows.
  ///
  /// In en, this message translates to:
  /// **'No rows match.'**
  String get dsNoRows;

  /// No description provided for @osNetwork.
  ///
  /// In en, this message translates to:
  /// **'network'**
  String get osNetwork;

  /// No description provided for @osOnline.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get osOnline;

  /// No description provided for @osOffline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get osOffline;

  /// No description provided for @osQueue.
  ///
  /// In en, this message translates to:
  /// **'queue'**
  String get osQueue;

  /// No description provided for @osSent.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get osSent;

  /// No description provided for @osRetries.
  ///
  /// In en, this message translates to:
  /// **'retries'**
  String get osRetries;

  /// No description provided for @osFailed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get osFailed;

  /// No description provided for @osLatency.
  ///
  /// In en, this message translates to:
  /// **'latency'**
  String get osLatency;

  /// No description provided for @osFailureRate.
  ///
  /// In en, this message translates to:
  /// **'failure rate'**
  String get osFailureRate;

  /// No description provided for @osAddTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get osAddTask;

  /// No description provided for @osReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get osReload;

  /// No description provided for @osClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get osClearAll;

  /// No description provided for @osOnlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Online. Changes are sent as you make them.'**
  String get osOnlineBanner;

  /// No description provided for @osOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline. Changes are kept on this device and sent when you reconnect.'**
  String get osOfflineBanner;

  /// No description provided for @osQueueEmpty.
  ///
  /// In en, this message translates to:
  /// **'queue: empty'**
  String get osQueueEmpty;

  /// No description provided for @osQueueItems.
  ///
  /// In en, this message translates to:
  /// **'queue: {items}'**
  String osQueueItems(String items);

  /// No description provided for @osSynced.
  ///
  /// In en, this message translates to:
  /// **'synced'**
  String get osSynced;

  /// No description provided for @osPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get osPending;

  /// No description provided for @osRetryCount.
  ///
  /// In en, this message translates to:
  /// **'retry {n}/{max}'**
  String osRetryCount(int n, int max);

  /// No description provided for @osRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get osRetry;

  /// No description provided for @osReloadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reload'**
  String get osReloadFailedTitle;

  /// No description provided for @osReloadFailedBody.
  ///
  /// In en, this message translates to:
  /// **'No connection. Showing what is saved on this device.'**
  String get osReloadFailedBody;

  /// No description provided for @osTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get osTryAgain;

  /// No description provided for @osNoTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get osNoTasksTitle;

  /// No description provided for @osNoTasksBody.
  ///
  /// In en, this message translates to:
  /// **'Add one. It will sync when it can.'**
  String get osNoTasksBody;

  /// No description provided for @rbRowsVisible.
  ///
  /// In en, this message translates to:
  /// **'rows visible'**
  String get rbRowsVisible;

  /// No description provided for @rbActionsAllowed.
  ///
  /// In en, this message translates to:
  /// **'actions allowed'**
  String get rbActionsAllowed;

  /// No description provided for @rbLastCheck.
  ///
  /// In en, this message translates to:
  /// **'last check'**
  String get rbLastCheck;

  /// No description provided for @rbNoneYet.
  ///
  /// In en, this message translates to:
  /// **'none yet'**
  String get rbNoneYet;

  /// No description provided for @rbAllowed.
  ///
  /// In en, this message translates to:
  /// **'allowed {perm}'**
  String rbAllowed(String perm);

  /// No description provided for @rbDenied.
  ///
  /// In en, this message translates to:
  /// **'denied {perm} (needs {who})'**
  String rbDenied(String perm, String who);

  /// No description provided for @rbNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs {who}'**
  String rbNeeds(String who);

  /// No description provided for @rbAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get rbAdmin;

  /// No description provided for @rbStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get rbStaff;

  /// No description provided for @rbCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get rbCustomer;

  /// No description provided for @rbAdminOrStaff.
  ///
  /// In en, this message translates to:
  /// **'Admin or Staff'**
  String get rbAdminOrStaff;

  /// No description provided for @rbSignedInAsMe.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}.'**
  String rbSignedInAsMe(String name);

  /// No description provided for @rbSignedInAsRole.
  ///
  /// In en, this message translates to:
  /// **'Signed in as a {role} account.'**
  String rbSignedInAsRole(String role);

  /// No description provided for @rbAllOrders.
  ///
  /// In en, this message translates to:
  /// **'All orders'**
  String get rbAllOrders;

  /// No description provided for @rbYourOrders.
  ///
  /// In en, this message translates to:
  /// **'Your orders'**
  String get rbYourOrders;

  /// No description provided for @rbAdvance.
  ///
  /// In en, this message translates to:
  /// **'Advance status'**
  String get rbAdvance;

  /// No description provided for @rbRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get rbRefund;

  /// No description provided for @rbExport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get rbExport;

  /// No description provided for @rbCancelMine.
  ///
  /// In en, this message translates to:
  /// **'Cancel mine'**
  String get rbCancelMine;

  /// No description provided for @rbRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get rbRefunded;

  /// No description provided for @rbCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get rbCancelled;

  /// No description provided for @rlDirection.
  ///
  /// In en, this message translates to:
  /// **'direction'**
  String get rlDirection;

  /// No description provided for @rlLocale.
  ///
  /// In en, this message translates to:
  /// **'locale'**
  String get rlLocale;

  /// No description provided for @rlTextSize.
  ///
  /// In en, this message translates to:
  /// **'text size'**
  String get rlTextSize;

  /// No description provided for @rlSubtotal.
  ///
  /// In en, this message translates to:
  /// **'subtotal'**
  String get rlSubtotal;

  /// No description provided for @rlDate.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get rlDate;

  /// No description provided for @rlLanguage.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get rlLanguage;

  /// No description provided for @rlEasternNumerals.
  ///
  /// In en, this message translates to:
  /// **'Eastern Arabic numerals'**
  String get rlEasternNumerals;

  /// No description provided for @mlMode.
  ///
  /// In en, this message translates to:
  /// **'mode'**
  String get mlMode;

  /// No description provided for @mlState.
  ///
  /// In en, this message translates to:
  /// **'state'**
  String get mlState;

  /// No description provided for @mlMoving.
  ///
  /// In en, this message translates to:
  /// **'moving'**
  String get mlMoving;

  /// No description provided for @mlSettled.
  ///
  /// In en, this message translates to:
  /// **'settled'**
  String get mlSettled;

  /// No description provided for @mlProgress.
  ///
  /// In en, this message translates to:
  /// **'progress'**
  String get mlProgress;

  /// No description provided for @mlPeakSpeed.
  ///
  /// In en, this message translates to:
  /// **'peak speed'**
  String get mlPeakSpeed;

  /// No description provided for @mlLastSettle.
  ///
  /// In en, this message translates to:
  /// **'last settle'**
  String get mlLastSettle;

  /// No description provided for @mlStudy.
  ///
  /// In en, this message translates to:
  /// **'study'**
  String get mlStudy;

  /// No description provided for @mlOrigami.
  ///
  /// In en, this message translates to:
  /// **'Origami'**
  String get mlOrigami;

  /// No description provided for @mlMagnetic.
  ///
  /// In en, this message translates to:
  /// **'Magnetic'**
  String get mlMagnetic;

  /// No description provided for @mlSheet.
  ///
  /// In en, this message translates to:
  /// **'Sheet'**
  String get mlSheet;

  /// No description provided for @mlStiffness.
  ///
  /// In en, this message translates to:
  /// **'stiffness'**
  String get mlStiffness;

  /// No description provided for @mlDamping.
  ///
  /// In en, this message translates to:
  /// **'damping'**
  String get mlDamping;

  /// No description provided for @mlDuration.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get mlDuration;

  /// No description provided for @mlFold.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get mlFold;

  /// No description provided for @mlUnfold.
  ///
  /// In en, this message translates to:
  /// **'Unfold'**
  String get mlUnfold;

  /// No description provided for @mlRepel.
  ///
  /// In en, this message translates to:
  /// **'repel instead of pull'**
  String get mlRepel;

  /// No description provided for @mlOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get mlOpen;

  /// No description provided for @mlClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mlClose;

  /// No description provided for @mlSlowMotion.
  ///
  /// In en, this message translates to:
  /// **'slow motion (÷4)'**
  String get mlSlowMotion;

  /// No description provided for @mlMapBlurb.
  ///
  /// In en, this message translates to:
  /// **'Map view\nDrag the sheet up and let go. It keeps the speed of your finger.'**
  String get mlMapBlurb;

  /// No description provided for @mlMotionStudy.
  ///
  /// In en, this message translates to:
  /// **'Motion study: {mode}'**
  String mlMotionStudy(String mode);

  /// No description provided for @mlPlace1.
  ///
  /// In en, this message translates to:
  /// **'Harbour Cafe · 120 m'**
  String get mlPlace1;

  /// No description provided for @mlPlace2.
  ///
  /// In en, this message translates to:
  /// **'Old Library · 300 m'**
  String get mlPlace2;

  /// No description provided for @mlPlace3.
  ///
  /// In en, this message translates to:
  /// **'Central Market · 450 m'**
  String get mlPlace3;

  /// No description provided for @mlPlace4.
  ///
  /// In en, this message translates to:
  /// **'Riverside Park · 800 m'**
  String get mlPlace4;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
