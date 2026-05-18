# Nexus Patio Tech — Prueba Técnica Mobile Developer (Flutter)

Aplicación móvil que permite buscar y navegar un catálogo de productos consumiendo la API pública de [DummyJSON](https://dummyjson.com), con persistencia local de los últimos productos visitados.

---

## Requisitos del entorno

| Herramienta | Versión |
|---|---|
| Flutter | **3.41.9** (stable) |
| Dart | **3.11.5** |
| DevTools | 2.54.2 |

> Verificar versión instalada: `flutter --version`

---

## Instalación y ejecución

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd nexustestapp

# 2. Instalar dependencias
flutter pub get

# 3. Correr en dispositivo/emulador conectado
flutter run

# 4. (Opcional) Correr en modo release
flutter run --release
```

> Se requiere un dispositivo físico o emulador Android/iOS activo. Para listar dispositivos disponibles: `flutter devices`

---

## Funcionalidades implementadas

- **Listado de productos** en grid de 2 columnas con imagen, título, precio y rating
- **Búsqueda** por texto con ejecución al presionar el ícono de buscar
- **Filtro por categoría** con chips horizontales (toque doble para deseleccionar)
- **Detalle del producto** con carrusel de imágenes, precio, descuento, stock, descripción y tags
- **Últimos 5 visitados** persistidos localmente y mostrados en carrusel en la pantalla principal
- **Skeleton loader** animado durante la carga de productos
- **Manejo de errores** con pantalla de reintento

---

## Arquitectura

El proyecto sigue los principios de **Clean Architecture** con separación en tres capas:

```
lib/
├── main.dart                          # Entry point (inicializa SharedPreferences)
└── src/
    └── modules/
        ├── common/
        │   └── managers/
        │       └── api_constants.dart # Constantes de la API
        └── core/
            ├── modular/
            │   ├── module.dart        # DI + rutas (ProductModule)
            │   └── navigation.dart    # Rutas constantes
            └── src/
                ├── domain/
                │   └── product.entity.dart       # Entidad pura de negocio
                ├── data/
                │   ├── dtos/
                │   │   └── product.dto.dart      # Modelo de la API (deserialización JSON)
                │   ├── mappers/
                │   │   └── product.mapper.dart   # DTO → Entity
                │   ├── repositories/
                │   │   └── product.repository.dart # Llamadas HTTP con Dio
                │   └── services/
                │       └── recent_products_service.dart # Persistencia local
                └── presentation/
                    ├── bloc/
                    │   ├── product_cubit.dart    # Lógica de estado
                    │   └── product_state.dart    # Estado inmutable
                    ├── pages/
                    │   ├── product.dart          # Home: búsqueda + categorías + grid
                    │   └── product_detail.dart   # Detalle con carrusel de imágenes
                    └── widgets/
                        ├── product_card.dart            # Card con imagen + gradient overlay
                        ├── product_skeleton.dart        # Skeleton animado (pulse)
                        ├── category_chip_widget.dart    # Chip con emoji por categoría
                        └── recent_products_carousel.dart # Carrusel de últimos visitados
```

---

## Decisiones técnicas

### `flutter_modular` para DI, rutas y estructura
Se usó como eje central del proyecto. `ProductModule` registra todas las dependencias (`Dio`, `ProductRepository`, `RecentProductsService`, `ProductCubit`) como singletons. Las rutas son declarativas y el `redirect '/' → '/product-home'` evita el error `RouteNotFoundException` al iniciar.

### `Cubit` en lugar de `Bloc` completo
Se eligió `Cubit` (parte del paquete `flutter_bloc`) porque el flujo de eventos es simple y unidireccional. No hay necesidad de mapear eventos a estados con `on<Event>()` ya que cada acción del usuario corresponde directamente a un método del cubit.

### Estado único con `copyWith`
`ProductState` es una clase inmutable con un solo método `copyWith`. Esto simplifica los rebuilds del `BlocBuilder` y mantiene el estado predecible. Los campos nullable (`error`, `selectedCategory`) se limpian explícitamente con flags `clearError` y `clearSelectedCategory`.

### Separación `context.read` → `BlocProvider.of`
`flutter_modular` y `flutter_bloc` generan un conflicto de extensión sobre `BuildContext.read`. Se resolvió usando `BlocProvider.of<ProductCubit>(context)` que no depende de la extensión ambigua.

### Persistencia con `SharedPreferences`
Se inicializa de forma asíncrona en `main()` antes de `runApp()` y se inyecta en el módulo. `RecentProductsService` serializa `ProductEntity` a JSON para guardar en `SharedPreferences`, valida duplicados por `id`, mantiene máximo 5 items y siempre inserta al frente (más reciente primero).

### `SharedPreferences` vs `Hive`/`SQLite`
Se eligió `SharedPreferences` porque el único dato persistente es una lista de máximo 5 productos simples. No hay consultas relacionales ni volumen que justifique una base de datos.

### Diseño visual
Paleta de la empresa: **negro `#1A1A1A`**, **naranja `#FF6B00`**, **blanco**. Las cards del grid usan imagen full-card con gradient overlay para maximizar el impacto visual. El carrusel de recientes usa un layout horizontal (imagen izquierda + detalle derecha) para diferenciarse visualmente del grid.

---

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| `flutter_modular` | ^6.4.1 | DI, navegación, estructura modular |
| `flutter_bloc` | ^9.1.1 | Gestión de estado (Cubit) |
| `bloc` | ^9.2.1 | Core del patrón BLoC |
| `dio` | ^5.9.2 | Cliente HTTP |
| `shared_preferences` | ^2.3.0 | Persistencia local de últimos visitados |

---

## API utilizada

**Base URL:** `https://dummyjson.com`

| Endpoint | Uso |
|---|---|
| `GET /products` | Listado general |
| `GET /products/search?q={query}` | Búsqueda por texto |
| `GET /products/category-list` | Lista de categorías |
| `GET /products/category/{category}` | Productos por categoría |
| `GET /products/{id}` | Detalle de producto |

---

## Posibles mejoras futuras

- **Paginación** — la API soporta `limit` y `skip`; implementar scroll infinito o paginación por páginas
- **Caché de red** — interceptor en Dio para cachear respuestas y funcionar offline
- **Use Cases** — agregar la capa de casos de uso entre repositorio y cubit para mayor adherencia a Clean Architecture
- **Interfaz abstracta del repositorio** — definir `IProductRepository` en domain para desacoplar la implementación
- **Tests unitarios** — cubrir el `ProductCubit` y el `RecentProductsService` con `bloc_test` y `mocktail`
- **Tests de widgets** — verificar renderizado de `ProductCard` y `ProductSkeleton`
- **Internacionalización (i18n)** — soporte multi-idioma con `flutter_localizations`
- **Tema oscuro** — aprovechar la paleta existente (negro/naranja) para un dark theme nativo
- **Carrusel de imágenes en detalle** — indicador de gestos o auto-scroll
- **Filtros combinados** — búsqueda + categoría simultáneamente
