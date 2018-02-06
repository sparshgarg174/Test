/* Author		: Sachin Chavan
 * Description	: Custom Calendar for Lightning Experience.
 * Date			: April 2017
 */
public with sharing class CustomCalendarController {
    
    @AuraEnabled
    public static String getCalendarViewFor(String targetDateString, String calendarViewType) {
        Date targetDate = Date.valueOf(targetDateString);
        CalendarView calendarView = new CalendarView(targetDate, calendarViewType);
        
        return JSON.serialize(calendarView);
    }
    
    public class CalendarView {
        public String label { get; set; }
        public List<String> calendarDayHeaders { get; set; }
        public Date startOfMonth { get; set; }
        public Date endOfMonth { get; set; }
        public Integer daysInMonth { get; set; }
        public Boolean isCurrentWeek { get; set; }
        public List<CalendarWeek> weeks { get; set; } 
        
        public CalendarView(Date targetDate, String calendarViewType) {
            this.isCurrentWeek = (System.today() >= targetDate.toStartOfWeek() && System.today() <= targetDate.toStartOfWeek().addDays(6));
            this.startOfMonth = targetDate.toStartOfMonth().toStartOfWeek();
            this.daysInMonth = Date.daysInMonth(targetDate.year(), targetDate.month());
            this.endOfMonth = Date.newInstance(targetDate.year(), targetDate.month(), daysInMonth);
            this.endOfMonth = endOfMonth.toStartOfWeek().addDays(6);
            this.weeks = new List<CalendarWeek>();
            
            if('monthlyView'.equalsIgnoreCase(calendarViewType)) {
                this.label = DateTime.newInstance(targetDate.year(), targetDate.month(), targetDate.day()).format('MMMM YYYY');
                this.calendarDayHeaders = new List<String>{'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'};
                    
                for(Integer iIndex = 0; iIndex < 6; iIndex++) {
                    Date currentWeek = startOfMonth.addDays(iIndex * 7);
                    CalendarWeek weekView = new CalendarWeek(currentWeek, targetDate, calendarViewType);
                    this.weeks.add(weekView);
                }
            } else if('weeklyView'.equalsIgnoreCase(calendarViewType)) {
                Date currentStartOfWeek = targetDate.toStartOfWeek();
                Date currentEndOfWeek = currentStartOfWeek.addDays(6);
                
                this.label = DateTime.newInstance(currentStartOfWeek.year(), currentStartOfWeek.month(), currentStartOfWeek.day()).format('MMMM dd, YYYY') + '–' + DateTime.newInstance(currentEndOfWeek.year(), currentEndOfWeek.month(), currentEndOfWeek.day()).format('MMMM dd, YYYY');
                this.calendarDayHeaders = new List<String>{'SUN ' + currentStartOfWeek.day(), 'MON ' +  + currentStartOfWeek.addDays(1).day(), 'TUE ' +  + currentStartOfWeek.addDays(2).day(), 'WED ' +  + currentStartOfWeek.addDays(3).day(), 'THU ' +  + currentStartOfWeek.addDays(4).day(), 'FRI ' +  + currentStartOfWeek.addDays(5).day(), 'SAT ' +  + currentStartOfWeek.addDays(6).day()};
                CalendarWeek weekView = new CalendarWeek(currentStartOfWeek, targetDate, calendarViewType);
                this.weeks.add(weekView);
            } else {
                this.label = DateTime.newInstance(targetDate.year(), targetDate.month(), targetDate.day()).format('MMMM dd, YYYY');
                this.calendarDayHeaders = new List<String>{DateTime.newInstance(targetDate.year(), targetDate.month(), targetDate.day()).format('EEEE')};
            }
        }
    }
    
    public class CalendarWeek {
        public String label { get; set; }
        public Date weekStartDate { get; set; }
        public Date weekEndDate { get; set; }
        public List<CalendarDay> days { get; set; }
        
        public CalendarWeek(Date currentWeek, Date targetDate, String calendarViewType) {
            this.weekStartDate = currentWeek;
            this.weekEndDate = currentWeek.addDays(6);
            this.label = this.weekStartDate + ' to ' + this.weekEndDate;
            this.days = new List<CalendarDay>();
            
            for(Integer iIndex = 0; iIndex < 7; iIndex++) {
                Date newDate = Date.newInstance(currentWeek.year(), currentWeek.month(), currentWeek.day() + iIndex);
                CalendarDay dayView = new CalendarDay(newDate, calendarViewType);
                dayView.styleClass += (newDate.month() == targetDate.month()) ? '' : ' neighbor';
                days.add(dayView);
            }
        }
    }
    
    public class CalendarDay {
        public Integer day { get; set; }
        public Integer month { get; set; }
        public Integer year { get; set; }
        public Date currentDate { get; set; }
        public String styleClass { get; set; }
        public String assistiveText { get; set; }
        
        public CalendarDay(Date newDate, String calendarViewType) {
            this.assistiveText = DateTime.newInstance(newDate.year(), newDate.month(), newDate.day()).format('EEEE, MMM dd YYYY');
            this.styleClass = '';
            this.currentDate = newDate;
            this.day = newDate.day();
            this.month = newDate.month();
            this.year = newDate.year();
            
            if('monthlyView'.equalsIgnoreCase(calendarViewType)) {
                this.styleClass += (System.today() == newDate ? ' today' : '');
            } else if('weeklyView'.equalsIgnoreCase(calendarViewType)) {
                this.styleClass += (System.today() == newDate ? ' presentDay' : ' pastDay');
            } else {
                this.styleClass += (System.today() == newDate ? ' today' : '');
            }
        }
    }
}