Функция ПодготовитьРезультаты(РезультатыБенчмарков) Экспорт
	
	ИнформацияОПроцессоре = РезультатыБенчмарков.СредаОкружения.ИнформацияОПроцессоре;

	УзелСредаОкружения = Новый Структура();
	УзелСредаОкружения.Вставить("ВерсияBenchmarkOneScript", РезультатыБенчмарков.СредаОкружения.ВерсияБиблиотеки);
	УзелСредаОкружения.Вставить("ВерсияOneScript", РезультатыБенчмарков.СредаОкружения.ВерсияПлатформы);
	УзелСредаОкружения.Вставить("ВерсияОС", РезультатыБенчмарков.СредаОкружения.ВерсияОС);
	УзелСредаОкружения.Вставить("ИмяПроцессора", ИнформацияОПроцессоре.ИмяПроцессора);
	УзелСредаОкружения.Вставить("КоличествоПроцессоров", ИнформацияОПроцессоре.КоличествоПроцессоров);
	УзелСредаОкружения.Вставить("КоличествоЯдер", ИнформацияОПроцессоре.КоличествоЯдер);
	УзелСредаОкружения.Вставить("КоличествоЛогическихПроцессоров", ИнформацияОПроцессоре.КоличествоЛогическихПроцессоров);

	УзелБенчмарки = Новый Массив();

	Для Каждого РезультатЗапуска Из РезультатыБенчмарков.РезультатыЗапусков Цикл
		
		УзелБенчмарк = Новый Структура();
		УзелБенчмарк.Вставить("Тип", Строка(РезультатЗапуска.ДескрипторБенчмарка.ТипОбъекта()));
		УзелБенчмарк.Вставить("Метод", РезультатЗапуска.ДескрипторБенчмарка.Метод());
		УзелБенчмарк.Вставить("Категория", РезультатЗапуска.ДескрипторБенчмарка.Категория());
		УзелБенчмарк.Вставить("Эталон", РезультатЗапуска.ДескрипторБенчмарка.ЭтоЭталон());
		УзелБенчмарк.Вставить("Параметры", Новый Структура());
		УзелБенчмарк.Вставить("Статистика", Новый Структура());

		Статистика = РезультатЗапуска.Статистика;
		УзелБенчмарк.Статистика.Вставить("Значения", Новый Массив());
		УзелБенчмарк.Статистика.Вставить("Количество", 0);
		УзелБенчмарк.Статистика.Вставить("Мин", Статистика.Мин);
		УзелБенчмарк.Статистика.Вставить("Q1", Статистика.НижнийКвартиль);
		УзелБенчмарк.Статистика.Вставить("Медиана", Статистика.Медиана);
		УзелБенчмарк.Статистика.Вставить("Среднее", Статистика.Среднее);
		УзелБенчмарк.Статистика.Вставить("Q3", Статистика.ВерхнийКвартиль);
		УзелБенчмарк.Статистика.Вставить("Макс", Статистика.Макс);
		УзелБенчмарк.Статистика.Вставить("СтандартноеОтклонение", Статистика.СтандартноеОтклонение);
		УзелБенчмарк.Статистика.Вставить("СтандартнаяОшибкаСреднего", Статистика.СтандартнаяОшибкаСреднего);
		УзелБенчмарк.Статистика.Вставить("ОперацийВСекунду", Статистика.ОперацийВСекунду);
		УзелБенчмарк.Статистика.Вставить("Процентили", Новый Структура());
		
		// BSLLS:MagicNumber-off
		УзелБенчмарк.Статистика.Процентили.Вставить("P0", Статистика.Квантиль(0));
		УзелБенчмарк.Статистика.Процентили.Вставить("P25", Статистика.Квантиль(0.25)); 
		УзелБенчмарк.Статистика.Процентили.Вставить("P50", Статистика.Квантиль(0.5));
		УзелБенчмарк.Статистика.Процентили.Вставить("P67", Статистика.Квантиль(0.67));
		УзелБенчмарк.Статистика.Процентили.Вставить("P80", Статистика.Квантиль(0.8));
		УзелБенчмарк.Статистика.Процентили.Вставить("P85", Статистика.Квантиль(0.85));
		УзелБенчмарк.Статистика.Процентили.Вставить("P90", Статистика.Квантиль(0.90));
		УзелБенчмарк.Статистика.Процентили.Вставить("P95", Статистика.Квантиль(0.95));
		УзелБенчмарк.Статистика.Процентили.Вставить("P100", Статистика.Квантиль(1));
		// BSLLS:MagicNumber-on

		УзелБенчмарк.Статистика.Вставить("Память", Новый Структура());
		УзелБенчмарк.Статистика.Память.Вставить("ВыделяемаяЗаОперацию", Статистика.ВыделяемаяПамять);

		Для Каждого Замер Из РезультатЗапуска.Замеры Цикл
			Если Замер.Этап = ЭтапыБенчмарка.Измерение Тогда
				УзелБенчмарк.Статистика.Значения.Добавить(Замер.НаносекундЗаОперацию);
			КонецЕсли;
		КонецЦикла;

		УзелБенчмарк.Статистика.Количество = УзелБенчмарк.Статистика.Значения.Количество();

		Для Каждого Параметр Из РезультатЗапуска.Параметры Цикл
			УзелБенчмарк.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
		КонецЦикла;

		УзелБенчмарки.Добавить(УзелБенчмарк);

	КонецЦикла;

	Данные = Новый Структура();
	Данные.Вставить("СредаОкружения", УзелСредаОкружения);
	Данные.Вставить("Бенчмарки", УзелБенчмарки);

	Возврат Данные;

КонецФункции