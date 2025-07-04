// BSLLS:ExportVariables-off

#Использовать cpuinfo

Перем ВерсияБиблиотеки Экспорт; // Строка
Перем ВерсияОС Экспорт; // Строка
Перем ВерсияИсполняющейСреды Экспорт; // Строка
Перем ИнформацияОПроцессоре Экспорт; // см. ИнформацияОПроцессоре

Процедура ПриСозданииОбъекта()
	
	ВерсияБиблиотеки = ПарсерОписанияПакета.НайтиИРаспарсить().Версия;

	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияОС = СистемнаяИнформация.ВерсияОС;
	ВерсияИсполняющейСреды = СистемнаяИнформация.Версия;
	
	ИнформацияОПроцессоре = Новый ИнформацияОПроцессоре();

КонецПроцедуры

Функция ВСтроку() Экспорт
	
	Процессор = ИнформацияОПроцессоре.ПолноеОписание();

	Если ПустаяСтрока(ВерсияИсполняющейСреды) Тогда
		Возврат СтрШаблон("BenchmarkOneScript v%1, %2
			|%3", ВерсияБиблиотеки, ВерсияОС, Процессор
		);
	Иначе
		Возврат СтрШаблон("BenchmarkOneScript v%1, OneScript v%2, %3
			|%4", ВерсияБиблиотеки, ВерсияИсполняющейСреды, ВерсияОС, Процессор
		);
	КонецЕсли;

КонецФункции
