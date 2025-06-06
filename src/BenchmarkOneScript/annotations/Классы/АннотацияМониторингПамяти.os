// Включает мониторинг выделения памяти и сборок мусора (GC).
//
// При использовании этой аннотации в отчете будут отображаться:
// - Аллокации памяти в байтах за итерацию
// - (нет) Количество сборок мусора для поколений (Gen 0, Gen 1, Gen 2) - пока нет необходимости, но средство получения есть
//
// Применяется только к методу ПриСозданииОбъекта.
//
// Пример:
//   &МониторингПамяти
//   Процедура ПриСозданииОбъекта()
//      // ...
//   КонецПроцедуры
&Аннотация("МониторингПамяти")
Процедура ПриСозданииОбъекта()
КонецПроцедуры