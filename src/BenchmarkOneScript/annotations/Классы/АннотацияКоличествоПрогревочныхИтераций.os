// Задает количество прогревочных итераций для подготовки окружения перед выполнением основных замеров бенчмарка.
//
// Прогревочные итерации используются для стабилизации системы: прогрев кэшей, 
// инициализация внешних ресурсов. Результаты этих итераций не учитываются в финальной статистике.
//
// - Применяется только к методу ПриСозданииОбъекта
// - Если установлено "0", то прогревочный этап будет пропущен
// - Игнорируется для стратегии "ХолодныйЗапуск"
//
// Примеры:
//   &КоличествоПрогревочныхИтераций(10)
//   Процедура ПриСозданииОбъекта()
//      // ...
//   КонецПроцедуры
&Аннотация("КоличествоПрогревочныхИтераций")
Процедура ПриСозданииОбъекта()
КонецПроцедуры