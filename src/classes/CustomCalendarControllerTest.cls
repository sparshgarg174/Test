/* Author		: Sachin Chavan
 * Description	: Custom Calendar for Lightning Experience.
 * Date			: April 2017
 */
@isTest
private class CustomCalendarControllerTest {

    @isTest static void customCalendarTest() {
        Test.startTest();
        String result = CustomCalendarController.getCalendarViewFor('2017-05-01', 'monthlyView');
        result = CustomCalendarController.getCalendarViewFor('2017-05-01', 'weeklyView');
        result = CustomCalendarController.getCalendarViewFor('2017-05-01', 'dailyView');
        Test.stopTest();
    }
    
}