;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname szeto-z-hw1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
;Zachary Szeto zdszeto

;Problem 1
;;Signature: make-date Natural Natural Natural -> Date
;; date-year: date-> Natural
;; date-month: date-> Natural
;; date-day: date -> Natural

(define-struct date (year month day))

;Examples
(define OPENING-DATE-THE-GODFATHER
  (make-date 1972 3 24))

(define OPENING-DATE-CITIZEN-KANE
  (make-date 1941 9 5))

(define OPENING-DATE-THE-WIZARD-OF-OZ
  (make-date 1939 8 25))

;Problem 2
;; a date is a (make-date Natural Natural Natural)
;; interp:  represents a date constrictor where
;;  year is its year (as a natural)
;;  month is its month (as a natural)
;;  day is its day (as a natural)

;Problem 1
;;Signature: make-film String String String Date Natural -> film
;; film-title: film  -> String
;; film-genre: film -> String
;; film-rating: film -> String
;; film-running-time: film -> Natural
;; film-opening-date: film -> make-date (Natural Natural Natural)
;; film-nominations: film -> Natural

(define-struct film (title genre rating running-time opening-date nominations))

;; Examples
(define THE-GODFATHER
  (make-film "The God Father" "drama" "R" 175 OPENING-DATE-THE-GODFATHER 11))

(define CITIZEN-KANE
  (make-film "Citizen Kane" "drama" "PG" 119 OPENING-DATE-CITIZEN-KANE 9))

(define THE-WIZARD-OF-OZ
  (make-film "The Wizard of Oz" "adventure" "PG" 102 OPENING-DATE-THE-WIZARD-OF-OZ 6))

;Problem 2
;; a film is a (make-film String String String Opening-Date Natural)
;; interp:  represents a film constrictor where
;;  title is the film's name
;;  genre is its genre(drama, comedy, family, etc.) 
;;  rating is its rating(G, PG, PG-13, R, NC-17, NR)
;;  running time of the film, in minutes 
;;  opening-date the film opened at the theater (it should include the year, month, and day) 
;;  nominations is the number of Oscar (Academy Award) nominations the film received 

;Problem 3
;;Signature: film -> Boolean
;;Purpose:consumes a film and returns true if it is a drama more than two and a half hours long or was both nominated for an Oscar and has a rating of NC-17 or NR.

(define (high-brow? a-film) 
  (or
   (and (string=? (film-genre a-film) "drama" ) (> (film-running-time a-film) 150))
   (and (> (film-nominations a-film) 0) (or (string=? (film-rating a-film) "NR")(string=? (film-rating a-film) "NC-17")))))

(check-expect (high-brow? THE-GODFATHER) #true) ;150 and drama
(check-expect (high-brow? (make-film "Test1" "adventure" "NC-17" 110 OPENING-DATE-THE-WIZARD-OF-OZ 6)) #true) ;NC-17 and award
(check-expect (high-brow? (make-film "Test2" "drama" "NR" 110 OPENING-DATE-THE-WIZARD-OF-OZ 1)) #true) ;NR and award
(check-expect (high-brow? (make-film "Test3" "adventure" "NC-17" 110 OPENING-DATE-THE-WIZARD-OF-OZ 0)) #false) ;NC-17 but no award
(check-expect (high-brow? (make-film "Test4" "drama" "NR" 90 OPENING-DATE-THE-WIZARD-OF-OZ 0)) #false) ;drama but not greater than 150 mins
(check-expect (high-brow? (make-film "Test5" "family" "R" 150 OPENING-DATE-THE-WIZARD-OF-OZ 1)) #false) ;not drama and not greater than 150 mins
(check-expect (high-brow? (make-film "Test6" "drama" "R" 150 OPENING-DATE-THE-WIZARD-OF-OZ 1)) #false) ;drama but onyl equal to 150 mins not greater than 150 mins
(check-expect (high-brow? (make-film "Test7" "adventure" "NR" 90 OPENING-DATE-THE-WIZARD-OF-OZ 0)) #false) ;NR but no award
(check-expect (high-brow? CITIZEN-KANE) #false) ;award but not NR or NC-17




;Problem 4
;;Signature: film film -> Natural
;;Purpose:consumes two films and produces a Number. The number produced is the sum of the Oscar nominations for the two films.  (You may assume the films are different.)
(define (total-nominations a-film1 a-film2)
  (+ (film-nominations a-film1) (film-nominations a-film2)))

(check-expect (total-nominations THE-GODFATHER THE-WIZARD-OF-OZ) 17)
(check-expect (total-nominations CITIZEN-KANE THE-WIZARD-OF-OZ) 15)
(check-expect (total-nominations THE-GODFATHER CITIZEN-KANE) 20)


;Problem 5
;;Signature: film Natural -> film
;;Purpose:consumes a film and a Number (representing the number of Oscar nominations), and produces a film. The film that is produced is the same as the original except that its nominations has been replaced by the given nominations.
(define (update-nominations a-film num-nominations)
  (make-film (film-title a-film) (film-genre a-film) (film-rating a-film) (film-running-time a-film) (film-opening-date a-film) num-nominations))

(check-expect (update-nominations THE-GODFATHER 278) (make-film "The God Father" "drama" "R" 175 OPENING-DATE-THE-GODFATHER 278))
(check-expect (update-nominations CITIZEN-KANE 0) (make-film "Citizen Kane" "drama" "PG" 119 OPENING-DATE-CITIZEN-KANE 0))
(check-expect (update-nominations THE-WIZARD-OF-OZ 129) (make-film "The Wizard of Oz" "adventure" "PG" 102 OPENING-DATE-THE-WIZARD-OF-OZ 129))


;Problem 6

;;Signature: date -> Natural
;;Purpose:consumes a date and produces the total number of days within that date (with a year being 365 days, a month being 31 days, and a day being 1 day)
(define (num-days a-date)(+ (* (date-year a-date) 365)(* (date-month a-date) 31) (date-day a-date))) ;helper function
(check-expect (num-days (make-date 2001 6 23)) 730574)
(check-expect (num-days (make-date 0 0 0)) 0)
(check-expect (num-days (make-date 1 9 17)) 661)


;;Signature: film date -> Boolean
;;Purpose:consumes a film and a date and produces true if the given film opened after the given date, and returns false otherwise

(define (opened-after? a-film a-date)(> (num-days(film-opening-date a-film)) (num-days a-date)))
(check-expect (opened-after? THE-GODFATHER (make-date 1971 3 17)) #true)
(check-expect (opened-after? THE-GODFATHER (make-date 2001 6 23)) #false)
(check-expect (opened-after? CITIZEN-KANE (make-date 0 0 0)) #true)
(check-expect (opened-after? CITIZEN-KANE (make-date 1941 9 6)) #false)
(check-expect (opened-after? THE-WIZARD-OF-OZ (make-date 1939 8 24)) #true)
(check-expect (opened-after? THE-WIZARD-OF-OZ (make-date 1939 8 25)) #false)
