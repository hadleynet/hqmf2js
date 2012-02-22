/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
Converts a a number in UTC Seconds since the epoch to a date.
@param {number} utcSeconds seconds since the epoch in UTC
@returns {Date}
@function
@exports dateFromUtcSeconds as hQuery.dateFromUtcSeconds
*/
hQuery.dateFromUtcSeconds = function(utcSeconds) {
  return new Date(utcSeconds * 1000);
};
/**
@class Scalar - a representation of a unit and value
@exports Scalar as hQuery.Scalar
*/
hQuery.Scalar = (function() {
  function Scalar(json) {
    this.json = json;
  }
  Scalar.prototype.unit = function() {
    return this.json['unit'];
  };
  Scalar.prototype.value = function() {
    return this.json['value'];
  };
  return Scalar;
})();
/**
@class A code with its corresponding code system
@exports CodedValue as hQuery.CodedValue
*/
hQuery.CodedValue = (function() {
  /**
  @param {String} c value of the code
  @param {String} csn name of the code system that the code belongs to
  @constructs
  */  function CodedValue(c, csn) {
    this.c = c;
    this.csn = csn;
  }
  /**
  @returns {String} the code
  */
  CodedValue.prototype.code = function() {
    return this.c;
  };
  /**
  @returns {String} the code system name
  */
  CodedValue.prototype.codeSystemName = function() {
    return this.csn;
  };
  /**
  Returns true if the contained code and codeSystemName match a code in the supplied codeSet.
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @returns {boolean}
  */
  CodedValue.prototype.includedIn = function(codeSet) {
    var code, codeSystemName, codes, _i, _len;
    for (codeSystemName in codeSet) {
      codes = codeSet[codeSystemName];
      if (this.csn === codeSystemName) {
        for (_i = 0, _len = codes.length; _i < _len; _i++) {
          code = codes[_i];
          if (code === this.c) {
            return true;
          }
        }
      }
    }
    return false;
  };
  return CodedValue;
})();
/**
Status as defined by value set 2.16.840.1.113883.5.14,
the ActStatus vocabulary maintained by HL7

@class Status
@augments hQuery.CodedEntry
@exports Status as hQuery.Status
*/
hQuery.Status = (function() {
  var ABORTED, ACTIVE, CANCELLED, COMPLETED, HELD, NEW, NORMAL, NULLIFIED, OBSOLETE, SUSPENDED;
  __extends(Status, hQuery.CodedValue);
  function Status() {
    Status.__super__.constructor.apply(this, arguments);
  }
  NORMAL = "normal";
  ABORTED = "aborted";
  ACTIVE = "active";
  CANCELLED = "cancelled";
  COMPLETED = "completed";
  HELD = "held";
  NEW = "new";
  SUSPENDED = "suspended";
  NULLIFIED = "nullified";
  OBSOLETE = "obsolete";
  Status.prototype.isNormal = function() {
    return this.c === NORMAL;
  };
  Status.prototype.isAborted = function() {
    return this.c === ABORTED;
  };
  Status.prototype.isActive = function() {
    return this.c === ACTIVE;
  };
  Status.prototype.isCancelled = function() {
    return this.c === CANCELLED;
  };
  Status.prototype.isCompleted = function() {
    return this.c === COMPLETED;
  };
  Status.prototype.isHeld = function() {
    return this.c === HELD;
  };
  Status.prototype.isNew = function() {
    return this.c === NEW;
  };
  Status.prototype.isSuspended = function() {
    return this.c === SUSPENDED;
  };
  Status.prototype.isNullified = function() {
    return this.c === NULLIFIED;
  };
  Status.prototype.isObsolete = function() {
    return this.c === OBSOLETE;
  };
  return Status;
})();
/**
@class an Address for a person or organization
@exports Address as hQuery.Address
*/
hQuery.Address = (function() {
  function Address(json) {
    this.json = json;
  }
  /**
  @returns {Array[String]} the street addresses
  */
  Address.prototype.street = function() {
    return this.json['streetAddress'];
  };
  /**
  @returns {String} the city
  */
  Address.prototype.city = function() {
    return this.json['city'];
  };
  /**
  @returns {String} the State
  */
  Address.prototype.state = function() {
    return this.json['stateOrProvince'];
  };
  /**
  @returns {String} the postal code
  */
  Address.prototype.postalCode = function() {
    return this.json['zip'];
  };
  return Address;
})();
/**
@class An object that describes a means to contact an entity.  This is used to represent
phone numbers, email addresses,  instant messaging accounts etc.
@exports Telecom as hQuery.Telecom
*/
hQuery.Telecom = (function() {
  function Telecom(json) {
    this.json = json;
  }
  /**
  @returns {String} the type of telecom entry, phone, sms, email ....
  */
  Telecom.prototype.type = function() {
    return this.json['type'];
  };
  /**
  @returns {String} the value of the entry -  the actual phone number , email address , ....
  */
  Telecom.prototype.value = function() {
    return this.json['value'];
  };
  /**
  @returns {String} the use of the entry. Is it a home, office, .... type of contact
  */
  Telecom.prototype.use = function() {
    return this.json['use'];
  };
  /**
  @returns {Boolean} is this a preferred form of contact
  */
  Telecom.prototype.preferred = function() {
    return this.json['preferred'];
  };
  return Telecom;
})();
/**
@class an object that describes a person.  includes a persons name, addresses, and contact information
@exports Person as hQuery.Person
*/
hQuery.Person = (function() {
  function Person(json) {
    this.json = json;
  }
  /**
   @returns {String} the given name of the person
  */
  Person.prototype.given = function() {
    return this.json['first'];
  };
  /**
   @returns {String} the last/family name of the person
  */
  Person.prototype.last = function() {
    return this.json['last'];
  };
  /**
   @returns {String} the display name of the person
  */
  Person.prototype.name = function() {
    if (this.json['name']) {
      return this.json['name'];
    } else {
      return this.json['first'] + ' ' + this.json['last'];
    }
  };
  /**
   @returns {Array} an array of {@link hQuery.Address} objects associated with the patient
  */
  Person.prototype.addresses = function() {
    var address, list, _i, _len, _ref;
    list = [];
    if (this.json['addresses']) {
      _ref = this.json['addresses'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        address = _ref[_i];
        list.push(new hQuery.Address(address));
      }
    }
    return list;
  };
  /**
  @returns {Array} an array of {@link hQuery.Telecom} objects associated with the person
  */
  Person.prototype.telecoms = function() {
    var tel, _i, _len, _ref, _results;
    _ref = this.json['telecoms'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tel = _ref[_i];
      _results.push(new hQuery.Telecom(tel));
    }
    return _results;
  };
  return Person;
})();
/**
@class an actor is either a person or an organization
@exports Actor as hQuery.Actor
*/
hQuery.Actor = (function() {
  function Actor(json) {
    this.json = json;
  }
  Actor.prototype.person = function() {
    if (this.json['person']) {
      return new hQuery.Person(this.json['person']);
    }
  };
  Actor.prototype.organization = function() {
    if (this.json['organization']) {
      return new hQuery.Organization(this.json['organization']);
    }
  };
  return Actor;
})();
/**
@class an Organization
@exports Organization as hQuery.Organization
*/
hQuery.Organization = (function() {
  function Organization(json) {
    this.json = json;
  }
  /**
  @returns {String} the id for the organization
  */
  Organization.prototype.organizationId = function() {
    return this.json['organizationId'];
  };
  /**
  @returns {String} the name of the organization
  */
  Organization.prototype.organizationName = function() {
    return this.json['organizationName'];
  };
  /**
  @returns {Array} an array of {@link hQuery.Address} objects associated with the organization
  */
  Organization.prototype.addresses = function() {
    var address, list, _i, _len, _ref;
    list = [];
    if (this.json['addresses']) {
      _ref = this.json['addresses'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        address = _ref[_i];
        list.push(new hQuery.Address(address));
      }
    }
    return list;
  };
  /**
  @returns {Array} an array of {@link hQuery.Telecom} objects associated with the organization
  */
  Organization.prototype.telecoms = function() {
    var tel, _i, _len, _ref, _results;
    _ref = this.json['telecoms'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tel = _ref[_i];
      _results.push(new hQuery.Telecom(tel));
    }
    return _results;
  };
  return Organization;
})();
/**
@class represents a DateRange in the form of hi and low date values.
@exports DateRange as hQuery.DateRange
*/
hQuery.DateRange = (function() {
  function DateRange(json) {
    this.json = json;
  }
  DateRange.prototype.hi = function() {
    if (this.json['hi']) {
      return hQuery.dateFromUtcSeconds(this.json['hi']);
    }
  };
  DateRange.prototype.low = function() {
    return hQuery.dateFromUtcSeconds(this.json['low']);
  };
  return DateRange;
})();
/**
@class Class used to describe an entity that is providing some form of information.  This does not mean that they are
providing any treatment just that they are providing information.
@exports Informant as hQuery.Informant
*/
hQuery.Informant = (function() {
  function Informant(json) {
    this.json = json;
  }
  /**
  an array of hQuery.Person objects as points of contact
  @returns {Array}
  */
  Informant.prototype.contacts = function() {
    var contact, _i, _len, _ref, _results;
    _ref = this.json['contacts'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      contact = _ref[_i];
      _results.push(new hQuery.Person(contact));
    }
    return _results;
  };
  /**
   @returns {hQuery.Organization} the organization providing the information
  */
  Informant.prototype.organization = function() {
    return new hQuery.Organization(this.json['organization']);
  };
  return Informant;
})();
/**
@class
@exports CodedEntry as hQuery.CodedEntry
*/
hQuery.CodedEntry = (function() {
  function CodedEntry(json) {
    this.json = json;
  }
  /**
  Date and time at which the coded entry took place
  @returns {Date}
  */
  CodedEntry.prototype.date = function() {
    return hQuery.dateFromUtcSeconds(this.json['time']);
  };
  /**
  An Array of CodedValues which describe what kind of coded entry took place
  @returns {Array}
  */
  CodedEntry.prototype.type = function() {
    return hQuery.createCodedValues(this.json['codes']);
  };
  /**
  A free text description of the type of coded entry
  @returns {String}
  */
  CodedEntry.prototype.freeTextType = function() {
    return this.json['description'];
  };
  /**
  Unique identifier for this coded entry
  @returns {String}
  */
  CodedEntry.prototype.id = function() {
    return this.json['id'];
  };
  /**
  Returns true if any of this entry's codes match a code in the supplied codeSet.
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @returns {boolean}
  */
  CodedEntry.prototype.includesCodeFrom = function(codeSet) {
    var codedValue, _i, _len, _ref;
    _ref = this.type();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      codedValue = _ref[_i];
      if (codedValue.includedIn(codeSet)) {
        return true;
      }
    }
    return false;
  };
  return CodedEntry;
})();
/**
@class Represents a list of hQuery.CodedEntry instances. Offers utility methods for matching
entries based on codes and date ranges
@exports CodedEntryList as hQuery.CodedEntryList
*/
hQuery.CodedEntryList = (function() {
  __extends(CodedEntryList, Array);
  function CodedEntryList() {
    this.push.apply(this, arguments);
  }
  /**
  Return the number of entries that match the
  supplied code set where those entries occur between the supplied time bounds
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @param {Date} start the start of the period during which the entry must occur, a null value will match all times
  @param {Date} end the end of the period during which the entry must occur, a null value will match all times
  @return {Array[CodedEntry]} the matching entries
  */
  CodedEntryList.prototype.match = function(codeSet, start, end) {
    var afterStart, beforeEnd, entry, matchingEntries, _i, _len;
    matchingEntries = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      entry = this[_i];
      afterStart = !start || entry.date() >= start;
      beforeEnd = !end || entry.date() <= end;
      if (afterStart && beforeEnd && entry.includesCodeFrom(codeSet)) {
        matchingEntries.push(entry);
      }
    }
    return matchingEntries;
  };
  return CodedEntryList;
})();
/**
@private
@function

*/
hQuery.createCodedValues = function(jsonCodes) {
  var code, codeSystem, codedValues, codes, _i, _len;
  codedValues = [];
  for (codeSystem in jsonCodes) {
    codes = jsonCodes[codeSystem];
    for (_i = 0, _len = codes.length; _i < _len; _i++) {
      code = codes[_i];
      codedValues.push(new hQuery.CodedValue(code, codeSystem));
    }
  }
  return codedValues;
};/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
@class MedicationInformation
@exports MedicationInformation as hQuery.MedicationInformation
*/
hQuery.MedicationInformation = (function() {
  function MedicationInformation(json) {
    this.json = json;
  }
  /**
  An array of hQuery.CodedValue describing the medication
  @returns {Array}
  */
  MedicationInformation.prototype.codedProduct = function() {
    return hQuery.createCodedValues(this.json['codes']);
  };
  MedicationInformation.prototype.freeTextProductName = function() {
    return this.json['description'];
  };
  MedicationInformation.prototype.codedBrandName = function() {
    return this.json['codedBrandName'];
  };
  MedicationInformation.prototype.freeTextBrandName = function() {
    return this.json['brandName'];
  };
  MedicationInformation.prototype.drugManufacturer = function() {
    if (this.json['drugManufacturer']) {
      return new hQuery.Organization(this.json['drugManufacturer']);
    }
  };
  return MedicationInformation;
})();
/**
@class AdministrationTiming - the
@exports AdministrationTiming as hQuery.AdministrationTiming
*/
hQuery.AdministrationTiming = (function() {
  function AdministrationTiming(json) {
    this.json = json;
  }
  /**
  Provides the period of medication administration as a Scalar. An example
  Scalar that would be returned would be with value = 8 and units = hours. This would
  mean that the medication should be taken every 8 hours.
  @returns {hQuery.Scalar}
  */
  AdministrationTiming.prototype.period = function() {
    return new hQuery.Scalar(this.json['period']);
  };
  /**
  Indicates whether it is the interval (time between dosing), or frequency 
  (number of doses in a time period) that is important. If instititutionSpecified is not 
  present or is set to false, then the time between dosing is important (every 8 hours). 
  If true, then the frequency of administration is important (e.g., 3 times per day).
  @returns {Boolean}
  */
  AdministrationTiming.prototype.institutionSpecified = function() {
    return this.json['institutionSpecified'];
  };
  return AdministrationTiming;
})();
/**
@class DoseRestriction -  restrictions on the medications dose, represented by a upper and lower dose
@exports DoseRestriction as hQuery.DoseRestriction
*/
hQuery.DoseRestriction = (function() {
  function DoseRestriction(json) {
    this.json = json;
  }
  DoseRestriction.prototype.numerator = function() {
    return new hQuery.Scalar(this.json['numerator']);
  };
  DoseRestriction.prototype.denominator = function() {
    return new hQuery.Scalar(this.json['denominator']);
  };
  return DoseRestriction;
})();
/**
@class Fulfillment - information about when and who fulfilled an order for the medication
@exports Fulfillment as hQuery.Fullfilement
*/
hQuery.Fulfillment = (function() {
  function Fulfillment(json) {
    this.json = json;
  }
  Fulfillment.prototype.dispenseDate = function() {
    return hQuery.dateFromUtcSeconds(this.json['dispenseDate']);
  };
  Fulfillment.prototype.provider = function() {
    return new hQuery.Actor(this.json['provider']);
  };
  Fulfillment.prototype.dispensingPharmacyLocation = function() {
    return new hQuery.Address(this.json['dispensingPharmacyLocation']);
  };
  Fulfillment.prototype.quantityDispensed = function() {
    return new hQuery.Scalar(this.json['quantityDispensed']);
  };
  Fulfillment.prototype.prescriptionNumber = function() {
    return this.json['prescriptionNumber'];
  };
  Fulfillment.prototype.fillNumber = function() {
    return this.json['fillNumber'];
  };
  Fulfillment.prototype.fillStatus = function() {
    return new hQuery.Status(this.json['fillStatus']);
  };
  return Fulfillment;
})();
/**
@class OrderInformation - information abour an order for a medication
@exports OrderInformation as hQuery.OrderInformation
*/
hQuery.OrderInformation = (function() {
  function OrderInformation(json) {
    this.json = json;
  }
  OrderInformation.prototype.orderNumber = function() {
    return this.json['orderNumber'];
  };
  OrderInformation.prototype.fills = function() {
    return this.json['fills'];
  };
  OrderInformation.prototype.quantityOrdered = function() {
    return new hQuery.Scalar(this.json['quantityOrdered']);
  };
  OrderInformation.prototype.orderExpirationDateTime = function() {
    return hQuery.dateFromUtcSeconds(this.json['orderExpirationDateTime']);
  };
  OrderInformation.prototype.orderDateTime = function() {
    return hQuery.dateFromUtcSeconds(this.json['orderDateTime']);
  };
  return OrderInformation;
})();
/**
TypeOfMedication as defined by value set 2.16.840.1.113883.3.88.12.3221.8.19
which pulls two values from SNOMED to describe whether a medication is
prescription or over the counter

@class TypeOfMedication - describes whether a medication is prescription or
       over the counter
@augments hQuery.CodedEntry
@exports TypeOfMedication as hQuery.TypeOfMedication
*/
hQuery.TypeOfMedication = (function() {
  var OTC, PRESECRIPTION;
  __extends(TypeOfMedication, hQuery.CodedValue);
  function TypeOfMedication() {
    TypeOfMedication.__super__.constructor.apply(this, arguments);
  }
  PRESECRIPTION = "73639000";
  OTC = "329505003";
  /**
  @returns {Boolean}
  */
  TypeOfMedication.prototype.isPrescription = function() {
    return this.c === PRESECRIPTION;
  };
  /**
  @returns {Boolean}
  */
  TypeOfMedication.prototype.isOverTheCounter = function() {
    return this.c === OTC;
  };
  return TypeOfMedication;
})();
/**
StatusOfMedication as defined by value set 2.16.840.1.113883.1.11.20.7
The terms come from SNOMED and are managed by HL7

@class StatusOfMedication - describes the status of the medication
@augments hQuery.CodedEntry
@exports StatusOfMedication as hQuery.StatusOfMedication
*/
hQuery.StatusOfMedication = (function() {
  var ACTIVE, NO_LONGER_ACTIVE, ON_HOLD, PRIOR_HISTORY;
  __extends(StatusOfMedication, hQuery.CodedValue);
  function StatusOfMedication() {
    StatusOfMedication.__super__.constructor.apply(this, arguments);
  }
  ON_HOLD = "392521001";
  NO_LONGER_ACTIVE = "421139008";
  ACTIVE = "55561003";
  PRIOR_HISTORY = "73425007";
  /**
  @returns {Boolean}
  */
  StatusOfMedication.prototype.isOnHold = function() {
    return this.c === ON_HOLD;
  };
  /**
  @returns {Boolean}
  */
  StatusOfMedication.prototype.isNoLongerActive = function() {
    return this.c === NO_LONGER_ACTIVE;
  };
  /**
  @returns {Boolean}
  */
  StatusOfMedication.prototype.isActive = function() {
    return this.c === ACTIVE;
  };
  /**
  @returns {Boolean}
  */
  StatusOfMedication.prototype.isPriorHistory = function() {
    return this.c === PRIOR_HISTORY;
  };
  return StatusOfMedication;
})();
/**
@class represents a medication entry for a patient.
@augments hQuery.CodedEntry
@exports Medication as hQuery.Medication
*/
hQuery.Medication = (function() {
  __extends(Medication, hQuery.CodedEntry);
  function Medication() {
    Medication.__super__.constructor.apply(this, arguments);
  }
  /**
  @returns {String}
  */
  Medication.prototype.freeTextSig = function() {
    return this.json['freeTextSig'];
  };
  /**
  The actual or intended start of a medication. Slight deviation from greenCDA for C32 since
  it combines this with medication stop
  @returns {Date}
  */
  Medication.prototype.indicateMedicationStart = function() {
    return hQuery.dateFromUtcSeconds(this.json['start_time']);
  };
  /**
  The actual or intended stop of a medication. Slight deviation from greenCDA for C32 since
  it combines this with medication start
  @returns {Date}
  */
  Medication.prototype.indicateMedicationStop = function() {
    return hQuery.dateFromUtcSeconds(this.json['end_time']);
  };
  Medication.prototype.administrationTiming = function() {
    return new hQuery.AdministrationTiming(this.json['administrationTiming']);
  };
  /**
  @returns {CodedValue}  Contains routeCode or adminstrationUnitCode information.
    Route code shall have a a value drawn from FDA route of adminstration,
    and indicates how the medication is received by the patient.
    See http://www.fda.gov/Drugs/DevelopmentApprovalProcess/UCM070829
    The administration unit code shall have a value drawn from the FDA
    dosage form, source NCI thesaurus and represents the physical form of the
    product as presented to the patient.
    See http://www.fda.gov/Drugs/InformationOnDrugs/ucm142454.htm
  */
  Medication.prototype.route = function() {
    return new hQuery.CodedValue(this.json['route']['code'], this.json['route']['codeSystem']);
  };
  /**
  @returns {hQuery.Scalar} the dose
  */
  Medication.prototype.dose = function() {
    return new hQuery.Scalar(this.json['dose']);
  };
  /**
  @returns {CodedValue}
  */
  Medication.prototype.site = function() {
    return new hQuery.CodedValue(this.json['site']['code'], this.json['site']['codeSystem']);
  };
  /**
  @returns {hQuery.DoseRestriction}
  */
  Medication.prototype.doseRestriction = function() {
    return new hQuery.DoseRestriction(this.json['doseRestriction']);
  };
  /**
  @returns {String}
  */
  Medication.prototype.doseIndicator = function() {
    return this.json['doseIndicator'];
  };
  /**
  @returns {String}
  */
  Medication.prototype.fulfillmentInstructions = function() {
    return this.json['fulfillmentInstructions'];
  };
  /**
  @returns {CodedValue}
  */
  Medication.prototype.indication = function() {
    return new hQuery.CodedValue(this.json['indication']['code'], this.json['indication']['codeSystem']);
  };
  /**
  @returns {CodedValue}
  */
  Medication.prototype.productForm = function() {
    return new hQuery.CodedValue(this.json['productForm']['code'], this.json['productForm']['codeSystem']);
  };
  /**
  @returns {CodedValue}
  */
  Medication.prototype.vehicle = function() {
    return new hQuery.CodedValue(this.json['vehicle']['code'], this.json['vehicle']['codeSystem']);
  };
  /**
  @returns {CodedValue}
  */
  Medication.prototype.reaction = function() {
    return new hQuery.CodedValue(this.json['reaction']['code'], this.json['reaction']['codeSystem']);
  };
  /**
  @returns {CodedValue}
  */
  Medication.prototype.deliveryMethod = function() {
    return new hQuery.CodedValue(this.json['deliveryMethod']['code'], this.json['deliveryMethod']['codeSystem']);
  };
  /**
  @returns {hQuery.MedicationInformation}
  */
  Medication.prototype.medicationInformation = function() {
    return new hQuery.MedicationInformation(this.json);
  };
  /**
  @returns {hQuery.TypeOfMedication} Indicates whether this is an over the counter or prescription medication
  */
  Medication.prototype.typeOfMedication = function() {
    return new hQuery.TypeOfMedication(this.json['typeOfMedication']['code'], this.json['typeOfMedication']['codeSystem']);
  };
  /**
  Values conform to value set 2.16.840.1.113883.1.11.20.7 - Medication Status
  Values may be: On Hold, No Longer Active, Active, Prior History
  @returns {hQuery.StatusOfMedication}   Used to indicate the status of the medication.
  */
  Medication.prototype.statusOfMedication = function() {
    return new hQuery.StatusOfMedication(this.json['statusOfMedication']['code'], this.json['statusOfMedication']['codeSystem']);
  };
  /**
  @returns {String} free text instructions to the patient
  */
  Medication.prototype.patientInstructions = function() {
    return this.json['patientInstructions'];
  };
  /**
  @returns {Array} an array of {@link FulFillment} objects
  */
  Medication.prototype.fulfillmentHistory = function() {
    var order, _i, _len, _ref, _results;
    _ref = this.json['fulfillmentHistory'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      order = _ref[_i];
      _results.push(new hQuery.Fulfillment(order));
    }
    return _results;
  };
  /**
  @returns {Array} an array of {@link OrderInformation} objects
  */
  Medication.prototype.orderInformation = function() {
    var order, _i, _len, _ref, _results;
    _ref = this.json['orderInformation'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      order = _ref[_i];
      _results.push(new hQuery.OrderInformation(order));
    }
    return _results;
  };
  return Medication;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
@class CauseOfDeath
@exports CauseOfDeath as hQuery.CauseOfDeath
*/
hQuery.CauseOfDeath = (function() {
  function CauseOfDeath(json) {
    this.json = json;
  }
  /**
  @returns {hQuery.Date}
  */
  CauseOfDeath.prototype.timeOfDeath = function() {
    return new hQuery.dateFromUtcSeconds(this.json['timeOfDeath']);
  };
  /**
  @returns {int}
  */
  CauseOfDeath.prototype.ageAtDeath = function() {
    return this.json['ageAtDeath'];
  };
  return CauseOfDeath;
})();
/**
@class hQuery.Condition

This section is used to describe a patients problems/conditions. The types of conditions
described have been constrained to the SNOMED CT Problem Type code set. An unbounded
number of treating providers for the particular condition can be supplied.
@exports Condition as hQuery.Condition 
@augments hQuery.CodedEntry
*/
hQuery.Condition = (function() {
  __extends(Condition, hQuery.CodedEntry);
  function Condition(json) {
    this.json = json;
  }
  /**
   @returns {Array, hQuery.Provider} an array of providers for the condition
  */
  Condition.prototype.providers = function() {
    var provider, _i, _len, _ref, _results;
    _ref = this.json['treatingProviders'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      provider = _ref[_i];
      _results.push(new Provider(provider));
    }
    return _results;
  };
  /**
  Diagnosis Priority
  @returns {int}
  */
  Condition.prototype.diagnosisPriority = function() {
    return this.json['diagnosisPriority'];
  };
  /**
  age at onset
  @returns {int}
  */
  Condition.prototype.ageAtOnset = function() {
    return this.json['ageAtOnset'];
  };
  /**
  cause of death
  @returns {hQuery.CauseOfDeath}
  */
  Condition.prototype.causeOfDeath = function() {
    return new hQuery.CauseOfDeath(this.json['causeOfDeath']);
  };
  /**
  problem status
  @returns {hQuery.CodedValue}
  */
  Condition.prototype.problemStatus = function() {
    return new hQuery.CodedValue(this.json['problemStatus']['code'], this.json['problemStatus']['codeSystem']);
  };
  /**
  comment
  @returns {String}
  */
  Condition.prototype.comment = function() {
    return this.json['comment'];
  };
  return Condition;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
An Encounter is an interaction, regardless of the setting, between a patient and a
practitioner who is vested with primary responsibility for diagnosing, evaluating,
or treating the patient's condition. It may include visits, appointments, as well
as non face-to-face interactions. It is also a contact between a patient and a
practitioner who has primary responsibility for assessing and treating the
patient at a given contact, exercising independent judgment.
@class An Encounter is an interaction, regardless of the setting, between a patient and a
practitioner 
@augments hQuery.CodedEntry
@exports Encounter as hQuery.Encounter 
*/
hQuery.Encounter = (function() {
  __extends(Encounter, hQuery.CodedEntry);
  function Encounter() {
    Encounter.__super__.constructor.apply(this, arguments);
  }
  /**
  @returns {String}
  */
  Encounter.prototype.dischargeDisp = function() {
    return this.json['dischargeDisp'];
  };
  /**
  A code indicating the priority of the admission (e.g., Emergency, Urgent, Elective, et cetera) from
  National Uniform Billing Committee (NUBC)
  @returns {CodedValue}
  */
  Encounter.prototype.admitType = function() {
    return new hQuery.CodedValue(this.json['admitType']['code'], this.json['admitType']['codeSystem']);
  };
  /**
  @returns {hQuery.Actor}
  */
  Encounter.prototype.performer = function() {
    return new hQuery.Actor(this.json['performer']);
  };
  /**
  @returns {hQuery.Organization}
  */
  Encounter.prototype.facility = function() {
    return new hQuery.Organization(this.json['facility']);
  };
  /**
  @returns {hQuery.DateRange}
  */
  Encounter.prototype.encounterDuration = function() {
    return new hQuery.DateRange(this.json);
  };
  /**
  @returns {hQuery.CodedEntry}
  */
  Encounter.prototype.reasonForVisit = function() {
    return new hQuery.CodedEntry(this.json['reason']);
  };
  return Encounter;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
This represents all interventional, surgical, diagnostic, or therapeutic procedures or 
treatments pertinent to the patient.
@class
@augments hQuery.CodedEntry
@exports Procedure as hQuery.Procedure 
*/
hQuery.Procedure = (function() {
  __extends(Procedure, hQuery.CodedEntry);
  function Procedure() {
    Procedure.__super__.constructor.apply(this, arguments);
  }
  /**
  @returns {hQuery.Actor} The provider that performed the procedure
  */
  Procedure.prototype.performer = function() {
    return new hQuery.Actor(this.json['performer']);
  };
  /**
  @returns {hQuery.CodedValue} A SNOMED code indicating the body site on which the 
  procedure was performed
  */
  Procedure.prototype.site = function() {
    return new hQuery.CodedValue(this.json['site']['code'], this.json['site']['codeSystem']);
  };
  return Procedure;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
Observations generated by laboratories, imaging procedures, and other procedures. The scope
includes hematology, chemistry, serology, virology, toxicology, microbiology, plain x-ray,
ultrasound, CT, MRI, angiography, cardiac echo, nuclear medicine, pathology, and procedure
observations.
@class
@augments hQuery.CodedEntry
@exports Result as hQuery.Result 
*/
hQuery.Result = (function() {
  __extends(Result, hQuery.CodedEntry);
  function Result() {
    Result.__super__.constructor.apply(this, arguments);
  }
  /**
  ASTM CCR defines a restricted set of required result Type codes (see ResultTypeCode in section 7.3
  Summary of CCD value sets), used to categorize a result into one of several commonly accepted values
  (e.g. Hematology, Chemistry, Nuclear Medicine).
  @returns {CodedValue}
  */
  Result.prototype.resultType = function() {
    return this.type();
  };
  /**
  A status from the HL7 ActStatusNormal vocabulary
  @returns {String}
  */
  Result.prototype.status = function() {
    return this.json['status'];
  };
  /**
  Returns the value of the result. This will return an object. The properties of this
  object are dependent on the type of result.
  */
  Result.prototype.value = function() {
    return this.json['value'];
  };
  /**
  @returns {CodedValue}
  */
  Result.prototype.interpretation = function() {
    return new hQuery.CodedValue(this.json['interpretation'].code, this.json['interpretation'].codeSystem);
  };
  /**
  @returns {String}
  */
  Result.prototype.referenceRange = function() {
    return this.json['referenceRange'];
  };
  /**
  @returns {String}
  */
  Result.prototype.comment = function() {
    return this.json['comment'];
  };
  return Result;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
NoImmunzation as defined by value set 2.16.840.1.113883.1.11.19717
The terms come from Health Level Seven (HL7) Version 3.0 Vocabulary and are managed by HL7
It indicates the reason an immunization was not administered.

@class NoImmunization - describes the status of the medication
@augments hQuery.CodedEntry
@exports NoImmunization as hQuery.NoImmunization
*/
hQuery.NoImmunization = (function() {
  var IMMUNITY, MED_PRECAUTION, OUT_OF_STOCK, PAT_OBJ, PHIL_OBJ, REL_OBJ, VAC_EFF, VAC_SAFETY;
  __extends(NoImmunization, hQuery.CodedValue);
  function NoImmunization() {
    NoImmunization.__super__.constructor.apply(this, arguments);
  }
  IMMUNITY = "IMMUNE";
  MED_PRECAUTION = "MEDPREC";
  OUT_OF_STOCK = "OSTOCK";
  PAT_OBJ = "PATOBJ";
  PHIL_OBJ = "PHILISOP";
  REL_OBJ = "RELIG";
  VAC_EFF = "VACEFF";
  VAC_SAFETY = "VACSAF";
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isImmune = function() {
    return this.c === IMMUNITY;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isMedPrec = function() {
    return this.c === MED_PRECAUTION;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isOstock = function() {
    return this.c === OUT_OF_STOCK;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isPatObj = function() {
    return this.c === PAT_OBJ;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isPhilisop = function() {
    return this.c === PHIL_OBJ;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isRelig = function() {
    return this.c === REL_OBJ;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isVacEff = function() {
    return this.c === VAC_EFF;
  };
  /**
  @returns {Boolean}
  */
  NoImmunization.prototype.isVacSaf = function() {
    return this.c === VAC_SAFETY;
  };
  return NoImmunization;
})();
/**
@class represents a immunization entry for a patient.
@augments hQuery.CodedEntry
@exports Immunization as hQuery.Immunization
*/
hQuery.Immunization = (function() {
  __extends(Immunization, hQuery.CodedEntry);
  function Immunization(json) {
    this.json = json;
  }
  /**
  @returns{hQuery.Scalar} 
  */
  Immunization.prototype.medicationSeriesNumber = function() {
    return new hQuery.Scalar(this.json['medicationSeriesNumber']);
  };
  /**
  @returns{hQuery.MedicationInformation}
  */
  Immunization.prototype.medicationInformation = function() {
    return new hQuery.MedicationInformation(this.json);
  };
  /**
  @returns{Date} Date immunization was administered
  */
  Immunization.prototype.administeredDate = function() {
    return dateFromUtcSeconds(this.json['administeredDate']);
  };
  /**
  @returns{hQuery.Actor} Performer of immunization
  */
  Immunization.prototype.performer = function() {
    return new hQuery.Actor(this.json['performer']);
  };
  /**
  @returns {comment} human readable description of event
  */
  Immunization.prototype.comment = function() {
    return this.json['comment'];
  };
  /**
  @returns {Boolean} whether the immunization has been refused by the patient.
  */
  Immunization.prototype.refusalInd = function() {
    return this.json['refusalInd'];
  };
  /**
  NoImmunzation as defined by value set 2.16.840.1.113883.1.11.19717
  The terms come from Health Level Seven (HL7) Version 3.0 Vocabulary and are managed by HL7
  It indicates the reason an immunization was not administered.
  @returns {hQuery.NoImmunization}   Used to indicate reason an immunization was not administered.
  */
  Immunization.prototype.refusalReason = function() {
    return new hQuery.NoImmunization(this.json['refusalReason']['code'], this.json['refusalReason']['codeSystem']);
  };
  return Immunization;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
@class 
@augments hQuery.CodedEntry
@exports Allergy as hQuery.Allergy
*/
hQuery.Allergy = (function() {
  __extends(Allergy, hQuery.CodedEntry);
  function Allergy() {
    Allergy.__super__.constructor.apply(this, arguments);
  }
  /**
  Food and substance allergies use the Unique Ingredient Identifier(UNII) from the FDA
  http://www.fda.gov/ForIndustry/DataStandards/StructuredProductLabeling/ucm162523.htm
  
  Allegies to a class of medication Shall contain a value descending from the NDF-RT concept types 
  of Mechanism of Action - N0000000223, Physiologic Effect - N0000009802 or 
  Chemical Structure - N0000000002. NUI will be used as the concept code. 
  For more information, please see the Web Site 
  http://www.cancer.gov/cancertopics/terminologyresources/page5
  
  Allergies to a specific medication shall use RxNorm for the values.  
  @returns {CodedValue}
  */
  Allergy.prototype.product = function() {
    return this.type();
  };
  /**
  Date of allergy or adverse event
  @returns{Date}
  */
  Allergy.prototype.adverseEventDate = function() {
    return dateFromUtcSeconds(this.json['adverseEventDate']);
  };
  /**
  Adverse event types SHALL be coded as specified in HITSP/C80 Section 2.2.3.4.2 Allergy/Adverse Event Type
  @returns {CodedValue}
  */
  Allergy.prototype.adverseEventType = function() {
    return new hQuery.CodedValue(this.json['type']['code'], this.json['type']['codeSystem']);
  };
  /**
  This indicates the reaction that may be caused by the product or agent.  
   It is defined by 2.16.840.1.113883.3.88.12.3221.6.2 and are SNOMED-CT codes.
  420134006   Propensity to adverse reactions (disorder)
  418038007   Propensity to adverse reactions to substance (disorder)
  419511003   Propensity to adverse reactions to drug (disorder)
  418471000   Propensity to adverse reactions to food (disorder)
  419199007  Allergy to substance (disorder)
  416098002  Drug allergy (disorder)
  414285001  Food allergy (disorder)
  59037007  Drug intolerance (disorder)
  235719002  Food intolerance (disorder)
  @returns {CodedValue} 
  */
  Allergy.prototype.reaction = function() {
    return new hQuery.CodedValue(this.json['reaction']['code'], this.json['reaction']['codeSystem']);
  };
  /**
  This is a description of the level of the severity of the allergy or intolerance.
  Use SNOMED-CT Codes as defined by 2.16.840.1.113883.3.88.12.3221.6.8
    255604002  Mild
    371923003  Mild to Moderate
    6736007      Moderate
    371924009  Moderate to Severe
    24484000    Severe
    399166001  Fatal
  @returns {CodedValue} 
  */
  Allergy.prototype.severity = function() {
    return new hQuery.CodedValue(this.json['severity']['code'], this.json['severity']['codeSystem']);
  };
  /**
  Additional comment or textual information
  @returns {String}
  */
  Allergy.prototype.comment = function() {
    return this.json['comment'];
  };
  return Allergy;
})();/**
@namespace scoping into the hquery namespace
*/this.hQuery || (this.hQuery = {});
/**
@class 

@exports Provider as hQuery.Provider
*/
hQuery.Provider = (function() {
  function Provider(json) {
    this.json = json;
  }
  /**
  @returns {hQuery.Person}
  */
  Provider.prototype.providerEntity = function() {
    return new hQuery.Person(this.json['providerEntity']);
  };
  /**
  @returns {hQuery.DateRange}
  */
  Provider.prototype.careProvisionDateRange = function() {
    return new hQuery.DateRange(this.json['careProvisionDateRange']);
  };
  /**
  @returns {hQuery.CodedValue}
  */
  Provider.prototype.role = function() {
    return new hQuery.CodedValue(this.json['role']['code'], this.json['role']['codeSystem']);
  };
  /**
  @returns {String}
  */
  Provider.prototype.patientID = function() {
    return this.json['patientID'];
  };
  /**
  @returns {hQuery.CodedValue}
  */
  Provider.prototype.providerType = function() {
    return new hQuery.CodedValue(this.json['providerType']['code'], this.json['providerType']['codeSystem']);
  };
  /**
  @returns {String}
  */
  Provider.prototype.providerID = function() {
    return this.json['providerID'];
  };
  /**
  @returns {hQuery.Organization}
  */
  Provider.prototype.organizationName = function() {
    return new hQuery.Organization(this.json);
  };
  return Provider;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
@class 
@augments hQuery.CodedEntry
@exports Language as hQuery.Language
*/
hQuery.Language = (function() {
  __extends(Language, hQuery.CodedEntry);
  function Language(json) {
    this.json = json;
  }
  /**
  @returns {hQuery.CodedValue}
  */
  Language.prototype.modeCode = function() {
    return new hQuery.CodedValue(this.json['modeCode']['code'], this.json['modeCode']['codeSystem']);
  };
  /**
  @returns {String}
  */
  Language.prototype.preferenceIndicator = function() {
    return this.json['preferenceIndicator'];
  };
  return Language;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
This includes information about the patients current and past pregnancy status
The Coded Entry code system should be SNOMED-CT
@class
@augments hQuery.CodedEntry
@exports Pregnancy as hQuery.Pregnancy 
*/
hQuery.Pregnancy = (function() {
  __extends(Pregnancy, hQuery.CodedEntry);
  function Pregnancy() {
    Pregnancy.__super__.constructor.apply(this, arguments);
  }
  /**
  @returns {String}
  */
  Pregnancy.prototype.comment = function() {
    return this.json['comment'];
  };
  return Pregnancy;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**

The Social History Observation is used to define the patient's occupational, personal (e.g. lifestyle), 
social, and environmental history and health risk factors, as well as administrative data such as 
marital status, race, ethnicity and religious affiliation. The types of conditions
described have been constrained to the SNOMED CT code system using constrained code set, 2.16.840.1.113883.3.88.12.80.60:
229819007   Tobacco use and exposure
256235009   Exercise
160573003   Alcohol Intake
364393001   Nutritional observable
364703007   Employment detail
425400000   Toxic exposure status
363908000   Details of drug misuse behavior
228272008   Health-related behavior
105421008   Educational achievement

note:  Social History is not part of the existing green c32.
@exports Socialhistory as hQuery.Socialhistory 
@augments hQuery.CodedEntry
*/
hQuery.Socialhistory = (function() {
  __extends(Socialhistory, hQuery.CodedEntry);
  function Socialhistory(json) {
    this.json = json;
  }
  /**
  Value returns the value of the result. This will return an object. The properties of this
  object are dependent on the type of result.
  */
  Socialhistory.prototype.value = function() {
    return this.json['value'];
  };
  return Socialhistory;
})();/**
@namespace scoping into the hquery namespace
*/
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
this.hQuery || (this.hQuery = {});
/**
@class Supports
@exports Supports as hQuery.Supports
*/
hQuery.Supports = (function() {
  function Supports(json) {
    this.json = json;
  }
  /**
  @returns {DateRange}
  */
  Supports.prototype.supportDate = function() {
    return new hQuery.DateRange(this.json['supportDate']);
  };
  /**
  @returns {Person} 
  */
  Supports.prototype.guardian = function() {
    return new hQuery.Person(this.json['guardian']);
  };
  /**
  @returns {String}
  */
  Supports.prototype.guardianSupportType = function() {
    return this.json['guardianSupportType'];
  };
  /**
  @returns {Person}
  */
  Supports.prototype.contact = function() {
    return new hQuery.Person(this.json['contact']);
  };
  /**
  @returns {String}
  */
  Supports.prototype.contactSupportType = function() {
    return this.json['guardianSupportType'];
  };
  return Supports;
})();
/**
@class Representation of a patient
@augments hQuery.Person
@exports Patient as hQuery.Patient
*/
hQuery.Patient = (function() {
  __extends(Patient, hQuery.Person);
  function Patient() {
    Patient.__super__.constructor.apply(this, arguments);
  }
  /**
  @returns {String} containing M or F representing the gender of the patient
  */
  Patient.prototype.gender = function() {
    return this.json['gender'];
  };
  /**
  @returns {Date} containing the patient's birthdate
  */
  Patient.prototype.birthtime = function() {
    return hQuery.dateFromUtcSeconds(this.json['birthdate']);
  };
  /**
  @param (Date) date the date at which the patient age is calculated, defaults to now.
  @returns {number} the patient age in years
  */
  Patient.prototype.age = function(date) {
    var oneDay, oneYear;
    if (date == null) {
      date = new Date();
    }
    oneDay = 24 * 60 * 60 * 1000;
    oneYear = 365 * oneDay;
    return (date.getTime() - this.birthtime().getTime()) / oneYear;
  };
  /**
  @returns {CodedValue} the domestic partnership status of the patient
  The following HL7 codeset is used:
  A  Annulled
  D  Divorced
  I   Interlocutory
  L  Legally separated
  M  Married
  P  Polygamous
  S  Never Married
  T  Domestic Partner
  W  Widowed
  */
  Patient.prototype.maritalStatus = function() {
    if (this.json['maritalStatus']) {
      return new hQuery.CodedValue(this.json['maritalStatus']['code'], this.json['maritalStatus']['codeSystem']);
    }
  };
  /**
  @returns {CodedValue}  of the spiritual faith affiliation of the patient
  It uses the HL7 codeset.  http://www.hl7.org/memonly/downloads/v3edition.cfm#V32008
  */
  Patient.prototype.religiousAffiliation = function() {
    if (this.json['religiousAffiliation']) {
      return new hQuery.CodedValue(this.json['religiousAffiliation']['code'], this.json['religiousAffiliation']['codeSystem']);
    }
  };
  /**
  @returns {CodedValue}  of the race of the patient
  CDC codes:  http://phinvads.cdc.gov/vads/ViewCodeSystemConcept.action?oid=2.16.840.1.113883.6.238&code=1000-9
  */
  Patient.prototype.race = function() {
    if (this.json['race']) {
      return new hQuery.CodedValue(this.json['race']['code'], this.json['race']['codeSystem']);
    }
  };
  /**
  @returns {CodedValue} of the ethnicity of the patient
  CDC codes:  http://phinvads.cdc.gov/vads/ViewCodeSystemConcept.action?oid=2.16.840.1.113883.6.238&code=1000-9
  */
  Patient.prototype.ethnicity = function() {
    if (this.json['ethnicity']) {
      return new hQuery.CodedValue(this.json['ethnicity']['code'], this.json['ethnicity']['codeSystem']);
    }
  };
  /**
  @returns {CodedValue} This is the code specifying the level of confidentiality of the document.
  HL7 Confidentiality Code (2.16.840.1.113883.5.25)
  */
  Patient.prototype.confidentiality = function() {
    if (this.json['confidentiality']) {
      return new hQuery.CodedValue(this.json['confidentiality']['code'], this.json['confidentiality']['codeSystem']);
    }
  };
  /**
  @returns {Address} of the location where the patient was born
  */
  Patient.prototype.birthPlace = function() {
    return new hQuery.Address(this.json['birthPlace']);
  };
  /**
  @returns {Supports} information regarding key support contacts relative to healthcare decisions, including next of kin
  */
  Patient.prototype.supports = function() {
    return new hQuery.Supports(this.json['supports']);
  };
  /**
  @returns {Organization}
  */
  Patient.prototype.custodian = function() {
    return new hQuery.Organization(this.json['custodian']);
  };
  /**
  @returns {Provider}  the providers associated with the patient
  */
  Patient.prototype.provider = function() {
    return new hQuery.Provider(this.json['provider']);
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link hQuery.LanguagesSpoken} objects
  Code from http://www.ietf.org/rfc/rfc4646.txt representing the name of the human language
  */
  Patient.prototype.languages = function() {
    var language, list, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['languages']) {
      _ref = this.json['languages'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        language = _ref[_i];
        list.push(new hQuery.Language(language));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link hQuery.Encounter} objects
  */
  Patient.prototype.encounters = function() {
    var encounter, list, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['encounters']) {
      _ref = this.json['encounters'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        encounter = _ref[_i];
        list.push(new hQuery.Encounter(encounter));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Medication} objects
  */
  Patient.prototype.medications = function() {
    var list, medication, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['medications']) {
      _ref = this.json['medications'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        medication = _ref[_i];
        list.push(new hQuery.Medication(medication));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Condition} objects
  */
  Patient.prototype.conditions = function() {
    var condition, list, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['conditions']) {
      _ref = this.json['conditions'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        condition = _ref[_i];
        list.push(new hQuery.Condition(condition));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Procedure} objects
  */
  Patient.prototype.procedures = function() {
    var list, procedure, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['procedures']) {
      _ref = this.json['procedures'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        procedure = _ref[_i];
        list.push(new hQuery.Procedure(procedure));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Result} objects
  */
  Patient.prototype.results = function() {
    var list, result, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['results']) {
      _ref = this.json['results'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        result = _ref[_i];
        list.push(new hQuery.Result(result));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Result} objects
  */
  Patient.prototype.vitalSigns = function() {
    var list, vital, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['vital_signs']) {
      _ref = this.json['vital_signs'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vital = _ref[_i];
        list.push(new hQuery.Result(vital));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Immunization} objects
  */
  Patient.prototype.immunizations = function() {
    var immunization, list, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['immunizations']) {
      _ref = this.json['immunizations'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        immunization = _ref[_i];
        list.push(new hQuery.Immunization(immunization));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Allergy} objects
  */
  Patient.prototype.allergies = function() {
    var allergy, list, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['allergies']) {
      _ref = this.json['allergies'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        allergy = _ref[_i];
        list.push(new hQuery.Allergy(allergy));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Pregnancy} objects
  */
  Patient.prototype.pregnancies = function() {
    var list, pregnancy, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['pregnancies']) {
      _ref = this.json['pregnancies'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pregnancy = _ref[_i];
        list.push(new hQuery.Pregnancy(pregnancy));
      }
    }
    return list;
  };
  /**
  @returns {hQuery.CodedEntryList} A list of {@link Socialhistory} objects
  */
  Patient.prototype.socialhistories = function() {
    var list, socialhistory, _i, _len, _ref;
    list = new hQuery.CodedEntryList;
    if (this.json['socialhistories']) {
      _ref = this.json['socialhistories'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        socialhistory = _ref[_i];
        list.push(new hQuery.Socialhistory(socialhistory));
      }
    }
    return list;
  };
  return Patient;
})();