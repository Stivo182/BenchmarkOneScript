Перем ЭтоПервыйВызов;

&СтратегияХолодныйЗапуск
&КоличествоИтераций(5)
&КолонкаМин
&КолонкаМакс
Процедура ПриСозданииОбъекта()
КонецПроцедуры

&ПередВсеми
Процедура Инициализация() Экспорт
	ЭтоПервыйВызов = Истина;
КонецПроцедуры

&Бенчмарк
Процедура Бенчмарк() Экспорт
	
	Если ЭтоПервыйВызов Тогда
		ЭтоПервыйВызов = Ложь;
		Приостановить(1000);
	Иначе
		Приостановить(10);
	КонецЕсли;

КонецПроцедуры