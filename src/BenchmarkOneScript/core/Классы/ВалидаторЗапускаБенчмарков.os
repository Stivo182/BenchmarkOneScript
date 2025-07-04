#Использовать logos

Перем _ДескрипторыБенчмарков; // КоллекцияДескрипторовБенчмарков
Перем _Конфигурация; // КонфигурацияБенчмарков
Перем _СписокОшибок; // Массив из Строка

// Выполняет комплексную проверку для запуска бенчмарков
//
// Параметры:
//   ДескрипторыБенчмарков - КоллекцияДескрипторовБенчмарков
//   Конфигурация - КонфигурацияБенчмарков
Процедура ПриСозданииОбъекта(ДескрипторыБенчмарков, Конфигурация)
	_ДескрипторыБенчмарков = ДескрипторыБенчмарков;
	_Конфигурация = Конфигурация;
	_СписокОшибок = Новый Массив();
КонецПроцедуры

#Область ПрограммныйИнтерфейс

// Проверяет возможность выполнения бенчмарков
//
// Возвращаемое значение:
//   Булево - Истина, если все проверки пройдены (ошибок нет), 
//            Ложь в противном случае
Функция ЗапускВозможен() Экспорт

	_СписокОшибок.Очистить();

	ПроверитьНаличиеБенчмарков();
	ПроверитьТипыБенчмарков();
	ПроверитьЭталоннуюВерсиюИсполняющейСреды();
	ПроверитьЭталонныеБенчмарки();
	ПроверитьПараметрыНаВозможностьСериализации();
	ПроверитьОтсутствиеДелегатовПриНаличииДругойВерсииИсполняющейСреды();

	Возврат _СписокОшибок.Количество() = 0;

КонецФункции

// Формирует сводный отчет об ошибках валидации в виде строки
//
// Возвращаемое значение:
//   Строка
Функция ПолучитьТекстОшибок() Экспорт
	
	Подстроки = Новый Массив();
	Если _СписокОшибок.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;

	Подстроки.Добавить("Валидация запуска не пройдена. Обнаружены ошибки:");

	Для Каждого ТекстОшибки Из _СписокОшибок Цикл
		Подстроки.Добавить("- " + ТекстОшибки);
	КонецЦикла;

	Возврат СтрСоединить(Подстроки, Символы.ПС);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьНаличиеБенчмарков()

	Дескриптор = _ДескрипторыБенчмарков.ПолучитьПервый();
	Если Дескриптор = Неопределено Тогда
		_СписокОшибок.Добавить("Не найдены бенчмарки для запуска");
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьТипыБенчмарков()
	
	ПредыдущийТип = Неопределено;
	Для Каждого ДескрипторБенчмарка Из _ДескрипторыБенчмарков.ВМассив() Цикл

		ТекущийТип = ДескрипторБенчмарка.ТипОбъекта();
		Если ПредыдущийТип = Неопределено Тогда
			ПредыдущийТип = ТекущийТип;
		КонецЕсли;

		Если Не ПредыдущийТип = ТекущийТип Тогда
			ТекстОшибки = СтрШаблон("Запрещается запускать бенчмарки с разными типами: %1, %2...", ПредыдущийТип, ТекущийТип);
			_СписокОшибок.Добавить(ТекстОшибки);
			Возврат;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьЭталоннуюВерсиюИсполняющейСреды()
	
	Отбор = Новый Структура("ЭтоЭталон", Истина);
	НайденныеСтроки = _Конфигурация.ВерсииИсполняющейСреды().НайтиСтроки(Отбор);

	Если НайденныеСтроки.Количество() > 1 Тогда
		_СписокОшибок.Добавить("Допускается только одна эталонная версия исполняющей среды");
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЭталонныеБенчмарки()

	БылЭталонПоКатегории = Новый Соответствие();
	Для Каждого ДескрипторБенчмарка Из _ДескрипторыБенчмарков.ВМассив() Цикл

		Если Не ДескрипторБенчмарка.ЭтоЭталон() Тогда
			Продолжить;
		КонецЕсли;

		Категория = ДескрипторБенчмарка.Категория();

		Если БылЭталонПоКатегории[Категория] = Истина Тогда
			Если ЗначениеЗаполнено(Категория) Тогда
				_СписокОшибок.Добавить("В пределах одной категории может быть только один эталонный бенчмарк");
			Иначе
				_СписокОшибок.Добавить("Может быть только один эталонный бенчмарк");
			КонецЕсли;
		КонецЕсли;

		БылЭталонПоКатегории[Категория] = Истина;
	
	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьПараметрыНаВозможностьСериализации()

	Если Не ЕстьЭталоны() Или _Конфигурация.ИсполняющаяСредаОграниченаТекущей() Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Параметр Из _Конфигурация.Параметры() Цикл
		ПроверитьПараметрНаВозможностьСериализации(Параметр);
	КонецЦикла;

	Для Каждого ДескрипторБенчмарка Из _ДескрипторыБенчмарков.ВМассив() Цикл
		Для Каждого НаборыПараметров Из ДескрипторБенчмарка.НаборыПараметров() Цикл
			Для Каждого Параметр Из НаборыПараметров Цикл
				ПроверитьПараметрНаВозможностьСериализации(Параметр);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьПараметрНаВозможностьСериализации(Параметр)
	
	ШаблонОшибки = 
	"Значение параметра <%1> должно быть сериализуемым для определения эталонов между разными версиями OneScript";

	Если Не СериализацияОбъектовБенчмаркинга.ЗначениеСериализуется(Параметр.Значение) Тогда
		ТекстОшибки = СтрШаблон(ШаблонОшибки, Параметр.Имя);
		Если _СписокОшибок.Найти(ТекстОшибки) = Неопределено Тогда
			_СписокОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьОтсутствиеДелегатовПриНаличииДругойВерсииИсполняющейСреды()
	
	ТекстОшибки = 
	"Использование делегатов как обработчиков событий не поддерживается при запуске в разных версиях OneScript";

	Если _Конфигурация.ИсполняющаяСредаОграниченаТекущей() Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ОбработчикСобытия Из _Конфигурация.ОбработчикиСобытий() Цикл
		Если ТипЗнч(ОбработчикСобытия.Обработчик) = Тип("Делегат") Тогда
			_СписокОшибок.Добавить(ТекстОшибки);
			Возврат;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция ЕстьЭталоны()
		
	ЕстьЭталоннаяВерсия = _Конфигурация.ЭталоннаяВерсияИсполняющейСреды() <> Неопределено;
	ЕстьЭталонныеБенчмарки = _ДескрипторыБенчмарков.ПолучитьЭталонные().Количество() > 0;

	Возврат ЕстьЭталоннаяВерсия Или ЕстьЭталонныеБенчмарки;

КонецФункции

#КонецОбласти