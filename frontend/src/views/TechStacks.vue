<template>
  <div class="tech-stacks-page">
    <el-page-header @back="$router.go(-1)" :content="'Справочник технологических стеков'" />

    <el-tabs v-model="activeTab" class="mt-4">
      <!-- Вкладка: Все стеки -->
      <el-tab-pane label="Все стеки" name="all">
        <div class="mb-4 flex justify-between items-center">
          <el-input
            v-model="searchQuery"
            placeholder="Поиск стеков..."
            class="w-96"
            clearable
            @input="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>

          <el-button
            v-if="canManage"
            type="primary"
            @click="showCreateDialog = true"
          >
            <el-icon class="mr-2"><Plus /></el-icon>
            Добавить стек
          </el-button>
        </div>

        <!-- Список направлений с стеками -->
        <el-collapse v-model="activeDirections" class="direction-list">
          <el-collapse-item
            v-for="direction in directions"
            :key="direction.id"
            :name="direction.id"
          >
            <template #title>
              <div class="direction-header">
                <el-icon :style="{ color: direction.color }">
                  <component :is="direction.icon" />
                </el-icon>
                <span class="ml-2 font-semibold">{{ direction.name }}</span>
                <el-tag class="ml-2" size="small">{{ direction.stacks?.length || 0 }}</el-tag>
              </div>
            </template>

            <el-table
              :data="direction.stacks"
              style="width: 100%"
              :default-sort="{ prop: 'sortOrder', order: 'ascending' }"
            >
              <el-table-column prop="name" label="Название" width="200" />
              <el-table-column prop="code" label="Код" width="150" />
              <el-table-column prop="description" label="Описание" />
              <el-table-column label="Технологии" width="300">
                <template #default="{ row }">
                  <el-tag
                    v-for="tech in row.technologies"
                    :key="tech"
                    class="mr-1 mb-1"
                    size="small"
                  >
                    {{ tech }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="Статус" width="120">
                <template #default="{ row }">
                  <el-tag
                    :type="getStatusType(row.status)"
                    size="small"
                  >
                    {{ row.statusDisplayName }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="Действия" width="150" v-if="canManage">
                <template #default="{ row }">
                  <el-button
                    v-if="row.status === 'ACTIVE'"
                    size="small"
                    type="warning"
                    link
                    @click="handleDeprecate(row.id)"
                  >
                    Устарел
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-collapse-item>
        </el-collapse>
      </el-tab-pane>

      <!-- Вкладка: Предложенные стеки -->
      <el-tab-pane v-if="canManage" name="pending">
        <template #label>
          Предложенные
          <el-badge v-if="pendingCount > 0" :value="pendingCount" class="ml-2" />
        </template>

        <el-table :data="techStackStore.pendingStacks" style="width: 100%">
          <el-table-column prop="name" label="Название" width="200" />
          <el-table-column label="Направление" width="150">
            <template #default="{ row }">
              {{ row.directionName }}
            </template>
          </el-table-column>
          <el-table-column prop="description" label="Обоснование" />
          <el-table-column label="Технологии" width="300">
            <template #default="{ row }">
              <el-tag
                v-for="tech in row.technologies"
                :key="tech"
                class="mr-1 mb-1"
                size="small"
              >
                {{ tech }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="Автор" width="120">
            <template #default="{ row }">
              {{ row.createdByName }}
            </template>
          </el-table-column>
          <el-table-column label="Действия" width="180">
            <template #default="{ row }">
              <el-button
                size="small"
                type="success"
                @click="handleApprove(row)"
              >
                Согласовать
              </el-button>
              <el-button
                size="small"
                type="danger"
                @click="handleReject(row)"
              >
                Отклонить
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <!-- Диалог создания стека -->
    <el-dialog
      v-model="showCreateDialog"
      title="Добавить новый стек"
      width="600px"
    >
      <el-form
        ref="createFormRef"
        :model="createForm"
        :rules="createRules"
        label-width="140px"
      >
        <el-form-item label="Направление" prop="directionId">
          <el-select v-model="createForm.directionId" placeholder="Выберите направление" class="w-full">
            <el-option
              v-for="dir in directions"
              :key="dir.id"
              :label="dir.name"
              :value="dir.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="Код" prop="code">
          <el-input
            v-model="createForm.code"
            placeholder="JAVA, PYTHON, REACT..."
            @input="createForm.code = createForm.code.toUpperCase()"
          />
        </el-form-item>

        <el-form-item label="Название" prop="name">
          <el-input v-model="createForm.name" placeholder="Java, Python, React..." />
        </el-form-item>

        <el-form-item label="Описание">
          <el-input
            v-model="createForm.description"
            type="textarea"
            :rows="3"
            placeholder="Краткое описание стека"
          />
        </el-form-item>

        <el-form-item label="Технологии" prop="technologies">
          <el-select
            v-model="createForm.technologies"
            multiple
            filterable
            allow-create
            placeholder="Введите технологии"
            class="w-full"
          >
            <el-option
              v-for="tech in commonTechnologies"
              :key="tech"
              :label="tech"
              :value="tech"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="Порядок сортировки">
          <el-input-number v-model="createForm.sortOrder" :min="0" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="showCreateDialog = false">Отмена</el-button>
        <el-button type="primary" @click="handleCreate">Создать</el-button>
      </template>
    </el-dialog>

    <!-- Диалог согласования -->
    <el-dialog
      v-model="showApproveDialog"
      title="Согласование стека"
      width="500px"
    >
      <el-form label-width="100px">
        <el-form-item label="Название">
          <el-text>{{ approveStack?.name }}</el-text>
        </el-form-item>

        <el-form-item label="Код стека">
          <el-input
            v-model="approveCode"
            placeholder="Укажите код или оставьте пустым для автоген."
            @input="approveCode = approveCode.toUpperCase()"
          />
          <el-text size="small" type="info" class="mt-1">
            Оставьте пустым для автогенерации из названия
          </el-text>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="showApproveDialog = false">Отмена</el-button>
        <el-button type="success" @click="confirmApprove">Согласовать</el-button>
      </template>
    </el-dialog>

    <!-- Диалог отклонения -->
    <el-dialog
      v-model="showRejectDialog"
      title="Отклонение стека"
      width="500px"
    >
      <el-form>
        <el-form-item label="Причина">
          <el-input
            v-model="rejectReason"
            type="textarea"
            :rows="4"
            placeholder="Укажите причину отклонения"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="showRejectDialog = false">Отмена</el-button>
        <el-button type="danger" @click="confirmReject">Отклонить</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useTechStackStore } from '@/stores/techStack'
import { useAuthStore } from '@/stores/auth'
import { ElMessageBox } from 'element-plus'
import { Search, Plus } from '@element-plus/icons-vue'

const techStackStore = useTechStackStore()
const authStore = useAuthStore()

const activeTab = ref('all')
const searchQuery = ref('')
const activeDirections = ref([])
const showCreateDialog = ref(false)
const showApproveDialog = ref(false)
const showRejectDialog = ref(false)
const createFormRef = ref(null)

const approveStack = ref(null)
const approveCode = ref('')
const rejectStack = ref(null)
const rejectReason = ref('')

const createForm = ref({
  directionId: null,
  code: '',
  name: '',
  description: '',
  technologies: [],
  sortOrder: 0
})

const createRules = {
  directionId: [{ required: true, message: 'Выберите направление', trigger: 'change' }],
  code: [{ required: true, message: 'Введите код', trigger: 'blur' }],
  name: [{ required: true, message: 'Введите название', trigger: 'blur' }],
  technologies: [{ required: true, message: 'Добавьте хотя бы одну технологию', trigger: 'change' }]
}

const commonTechnologies = [
  'Spring Boot', 'Hibernate', 'JPA', 'Maven', 'Gradle',
  'Django', 'FastAPI', 'Flask', 'Celery',
  'React', 'Vue.js', 'Angular', 'Next.js', 'Nuxt.js',
  'TypeScript', 'JavaScript', 'Node.js', 'Express',
  'Docker', 'Kubernetes', 'Jenkins', 'GitLab CI',
  'PostgreSQL', 'MySQL', 'MongoDB', 'Redis',
  'AWS', 'Azure', 'GCP', 'Kafka', 'RabbitMQ'
]

const directions = computed(() => techStackStore.directions)
const pendingCount = computed(() => techStackStore.pendingStacks.length)
const canManage = computed(() =>
  authStore.hasRole('SYSTEM_ADMIN') || authStore.hasRole('DZO_ADMIN')
)

const getStatusType = (status) => {
  const types = {
    ACTIVE: 'success',
    DEPRECATED: 'warning',
    PROPOSED: 'info',
    REJECTED: 'danger'
  }
  return types[status] || 'info'
}

const handleSearch = async () => {
  if (searchQuery.value.trim()) {
    const results = await techStackStore.searchStacks(searchQuery.value)
    // Группируем результаты по направлениям
    const grouped = {}
    results.forEach(stack => {
      if (!grouped[stack.directionId]) {
        const dir = directions.value.find(d => d.id === stack.directionId)
        grouped[stack.directionId] = { ...dir, stacks: [] }
      }
      grouped[stack.directionId].stacks.push(stack)
    })
    techStackStore.directions = Object.values(grouped)
  } else {
    loadData()
  }
}

const handleCreate = async () => {
  await createFormRef.value.validate()
  await techStackStore.createStack(createForm.value)
  showCreateDialog.value = false
  resetCreateForm()
  loadData()
}

const handleApprove = (stack) => {
  approveStack.value = stack
  approveCode.value = ''
  showApproveDialog.value = true
}

const confirmApprove = async () => {
  await techStackStore.approveStack(
    approveStack.value.id,
    approveCode.value || null
  )
  showApproveDialog.value = false
  loadData()
}

const handleReject = (stack) => {
  rejectStack.value = stack
  rejectReason.value = ''
  showRejectDialog.value = true
}

const confirmReject = async () => {
  if (!rejectReason.value.trim()) {
    ElMessage.warning('Укажите причину отклонения')
    return
  }
  await techStackStore.rejectStack(rejectStack.value.id, rejectReason.value)
  showRejectDialog.value = false
}

const handleDeprecate = async (id) => {
  await ElMessageBox.confirm(
    'Стек будет помечен как устаревший. Продолжить?',
    'Подтверждение',
    { type: 'warning' }
  )
  await techStackStore.deprecateStack(id)
  loadData()
}

const resetCreateForm = () => {
  createForm.value = {
    directionId: null,
    code: '',
    name: '',
    description: '',
    technologies: [],
    sortOrder: 0
  }
}

const loadData = async () => {
  await techStackStore.fetchDirections(true)
  if (canManage.value) {
    await techStackStore.fetchPendingStacks()
  }
  // Раскрываем все направления по умолчанию
  activeDirections.value = directions.value.map(d => d.id)
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.tech-stacks-page {
  padding: 20px;
}

.direction-header {
  display: flex;
  align-items: center;
  font-size: 16px;
}

.direction-list {
  margin-top: 20px;
}
</style>
