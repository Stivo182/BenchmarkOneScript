// Аннотация определяет среду исполнения для запуска бенчмарков.
//
// Применяется только к методу ПриСозданииОбъекта.
//
// Параметры:
//   Версия - Строка - Версия OneScript:
//     1) Номер версии ("1.9.3")
//     2) Алиас ("stable", "dev")
//     3) Абсолютный путь к исполняемому файлу ("path/to/oscript.exe")
//   Наименование - Строка - Произвольное имя среды для отчета
//   ЭтоЭталон - Булево - Флаг эталонной среды для сравнения результатов
//
// Примеры:
//   1) &ИсполняющаяСреда("stable")
//      &ИсполняющаяСреда("dev")
//      &ИсполняющаяСреда("path/to/oscript.exe")
//      Процедура ПриСозданииОбъекта()
//         // ...
//      КонецПроцедуры
//
//   2) &ИсполняющаяСреда("1.9.3, dev")
//      Процедура ПриСозданииОбъекта()
//         // ...
//      КонецПроцедуры
//
//   3) &ИсполняющаяСреда(
//         Версия = "stable"
//         Наименование = "Стабильная",
//         ЭтоЭталон = Истина
//      ) 
//      Процедура ПриСозданииОбъекта()
//         // ...
//      КонецПроцедуры
&Аннотация("ИсполняющаяСреда")
Процедура ПриСозданииОбъекта(Версия, Наименование = "", ЭтоЭталон = Ложь)
КонецПроцедуры